class ShoppingListsController < ApplicationController
  include IngredientsAggregator
  include ShoppingListUpdater
  before_action :ensure_cart_is_not_empty, only: [:create]

  def index
    shopping_list = current_user_cart.shopping_list

    # ショッピングリストメニューを取得
    shopping_list_menus = shopping_list.shopping_list_menus.includes(menu: [image_attachment: :blob])

    # ShoppingListMenuが空の場合はroot_pathへリダイレクト
    if shopping_list_menus.empty?
      redirect_to root_path and return
    end

    # メニューデータとカウントを取得
    @menus = shopping_list_menus.map(&:menu)
    @menu_item_counts = shopping_list_menus.each_with_object({}) do |slm, counts|
      counts[slm.menu_id] = slm.menu_count
    end

    # ショッピングリストアイテムをカテゴリIDに基づいてグループ化する
    shopping_list_items_by_category = shopping_list.shopping_list_items.includes(:material).group_by do |item|
      item.material.category_id
    end

    # すべてのカテゴリを取得して、IDと名前のハッシュを作成
    @categories = Category.all.index_by(&:id).transform_values(&:category_name)

    # カテゴリIDでソートした結果をインスタンス変数に代入
    @shopping_lists = shopping_list_items_by_category.sort_by { |category_id, _items| category_id }.to_h

    # JSで動的にデータ更新するため、各カテゴリ内でアイテムをIDに基づいてソート
    @shopping_lists.each do |category_id, items|
      items.sort_by!(&:id)
    end
  end


  def create
    begin
      ActiveRecord::Base.transaction do
        # カートの中にあるmenu_idとその個数のデータを取得
        cart_items = current_user_cart.cart_items
        # ショッピングリストを取得または作成
        shopping_list = current_user_cart.shopping_list || current_user_cart.create_shopping_list

        # チェック済みの食材リストデータを直接データベースから取得
        checked_items = ShoppingListItem.where(shopping_list_id: shopping_list.id, is_checked: true)

        # ショッピングリストの中にある食材リストを取得し、チェックされている項目を取得し、
        # その中に同じ食材があれば合算する処理
        aggregate_and_update_checked_items(checked_items)

        # カート内のアイテムから献立IDと数量のハッシュを生成するメソッド
        menu_item_counts = get_menu_item_counts(cart_items)
        # カート内のアイテムに基づいて必要な食材を取得し、それらを必要な量だけ複製する
        ingredients_duplicated = duplicate_ingredients_for_menu(cart_items, menu_item_counts)

        # ingredient_idに紐づく食材データを取得
        # １つ食材idごとに紐づく食材（material_id、unit_id、quantityを含む）データを取得
        ingredients = ingredients_duplicated.map(&:ingredient)

        # ingredientsで取得したデータで同じ食材データを持つものは１つにまとめる
        # 「aggregate_ingredients」はカスタムモジュール
        # 中身は「material_name、quantity、unit_name」が格納されている
        aggregated_ingredients = aggregate_ingredients(ingredients)

        # 集約された材料データからShoppingListItemのインスタンスを作成
        shopping_list_items_instances = create_shopping_list_items(aggregated_ingredients, shopping_list)

        # is_checked: false のレコードをすべて削除
        shopping_list.shopping_list_items.where(is_checked: false).delete_all

        # find_matching_items メソッドを呼び出して一致するアイテムのペアを取得
        matching_items = find_matching_items(checked_items, shopping_list_items_instances)

        # 「該当するデータがない場合」「is_checked: trueはあるがmatching_itemsはない場合」は既存のアイテムを削除し新規に作成
        if !shopping_list.shopping_list_items.where(is_checked: true).exists? || matching_items.empty?
          reset_and_create_shopping_list_items(shopping_list, shopping_list_items_instances, menu_item_counts)
        end

        # matching_itemsがある場合は必要データは残して後は削除
        if !matching_items.empty?
          # checked_items と shopping_list_items_instances のデータを処理
          process_shopping_list(shopping_list,matching_items, shopping_list_items_instances, menu_item_counts)
        end
      end
    rescue ActiveRecord::RecordInvalid
      handle_general_error
      return
    end

    redirect_to shopping_lists_path
    return
  end

  # 献立を減少（削除）を行う際に食材リストですでにチェックされている値（例：✔︎鶏肉 200g）が
  # 変更される場合に確認ダイヤログを出す指示をするアクション
  def check_items
    # パラメータからmenu_idとitem_countを取得
    # 削除の時は「menu_id」のみで数量変更の場合には「menu_id」と「item_count」が渡される
    menu_id_to_remove = params[:menu_id]
    item_count_to_remove = params[:item_count]

    # 初期状態では、ショッピングリストのチェック済みデータに影響がないと仮定する。
    # requires_attention は、チェック済みのデータに影響がある場合にtrueに設定され、
    # 確認ダイアログが必要かどうかを決定するために使用される。
    requires_attention = false

    # ショッピングリストを取得または作成
    shopping_list = current_user_cart.shopping_list || current_user_cart.create_shopping_list
    # チェック済みの食材リストデータをデータベースから取得
    checked_items = ShoppingListItem.where(shopping_list_id: shopping_list.id, is_checked: true)

    # チェック済みの食材リストデータで同じ食材があれば合算する処理
    # 例：✔︎鶏肉 200g, ✔︎鶏肉 100g → ✔︎鶏肉 300g
    aggregate_and_update_checked_items(checked_items)
    # カートの中にある献立データを取得
    cart_items = current_user_cart.cart_items

    # cart_itemsから指定されたmenu_idを持つアイテムを更新または除外
    # データを減らし、実際のデータと比較することで食材リストのチェックされている値（例：✔︎鶏肉 200g）に影響があるかチェック
    # 減少（削除）したデータ作成

    # デフォルトのアイテム数減少量
    default_item_count_decrement = @settings.dig('cart', 'default_item_count_decrement')

    # 数量変更の場合の処理
    # 献立の作る数量を減少させた場合の食材リストデータ（仮）を作成
    if item_count_to_remove
      # 指定されたmenu_idのアイテムの数量を減らす
      cart_item_to_update = cart_items.find { |item| item.menu_id.to_s == menu_id_to_remove }
      cart_item_to_update.item_count -= default_item_count_decrement
      # updated_cart_items に cart_item_to_update を追加
      updated_cart_items = [cart_item_to_update]
      # cart_items から cart_item_to_update の menu_id に該当しないアイテムを updated_cart_items に追加
      cart_items.each do |item|
        updated_cart_items << item unless item.menu_id.to_s == menu_id_to_remove
      end

    # 献立を削除させた場合の食材リストデータを作成
    else
      # menu_id_to_remove に該当するアイテムを除外
      updated_cart_items = cart_items.reject { |item| item.menu_id.to_s == menu_id_to_remove }
    end

    # 食材リストデータが空の場合に、既存の食材リストの中にチェックが入った食材があれば、
    # 「確認ダイヤログ」を出す指示を出す。なければ関連データを削除して食材リストをリセット
    if updated_cart_items.empty?
      handle_empty_cart_items(shopping_list)
      return
    end

    # 食材リストデータ（仮）から献立IDと数量のハッシュを生成
    menu_item_counts = get_menu_item_counts(updated_cart_items)
    # 食材リストデータ（仮）に基づいて必要な食材を取得し、必要な量だけ複製
    ingredients_duplicated = duplicate_ingredients_for_menu(updated_cart_items, menu_item_counts)

    # ingredient_idに紐づく食材データを取得
    # １つ食材idごとに紐づく食材（material_id、unit_id、quantityを含む）データを取得
    ingredients = ingredients_duplicated.map(&:ingredient)

    # 同じ食材データを持つものは１つにまとめる
    # 「aggregate_ingredients」はカスタムモジュール
    aggregated_ingredients = aggregate_ingredients(ingredients)

    # 集約された食材リストデータ（仮）をShoppingListItemのインスタンスとして作成
    shopping_list_items_instances = create_shopping_list_items(aggregated_ingredients, shopping_list)
    # 食材リストデータ（仮）の中にチェック済みの食材データがない場合
    if !shopping_list.shopping_list_items.where(is_checked: true).exists?
      render json: { requires_attention: false }
      return
    end

    # 既存の食材リストデータの中にあるチェック済みの食材データが、食材リストデータ（仮）に含まれている場合にそのデータを取得
    matching_items = find_matching_items(checked_items, shopping_list_items_instances)
    # 既存の食材リストデータの中にチェック済みの食材データはあるが、そのデータは食材リストデータ（仮）に含まれていない場合
    if matching_items.empty?
      render json: { requires_attention: true }
      return
    end

    # 既存の食材リストデータを取得し、その中でチェックされていない食材データがあれば取得
    grouped_items = group_related_items_by_material_id(checked_items, shopping_list.id)

    # チェックされている食材データのほかに、同じ食材データだけどチェックはされていない食材データがあるかをチェック
    # is_checked: false のデータが存在する場合に is_checked: true のデータを削除したグループ
    groups_with_unchecked_only = {}
    # is_checked: false のデータがないグループ
    groups_without_unchecked = {}

    grouped_items.each do |material_id, items|
      # is_checked: false のアイテムが存在するか確認
      if items.any? { |item| !item.is_checked }
        # is_checked: true のアイテムを除外して新しいリストを作成
        groups_with_unchecked_only[material_id] = items.select { |item| !item.is_checked }
      else
        # is_checked: false のアイテムが一つもない場合、このグループを別の変数に格納
        groups_without_unchecked[material_id] = items
      end
    end

    # 未チェックの食材アイテム間で相殺できるかチェック
    # 相殺できる場合にはチェック済みの食材の数値が変動はないため「requires_attention = false」にします。
    # もし変更する数量が多く、未チェックの食材データ分ではカバーできない場合、チェック済みの食材の数値が変動するため、
    # 「requires_attention = true」にします。
    if !groups_with_unchecked_only.empty?
      requires_attention = compare_unchecked_and_new_items(groups_with_unchecked_only, shopping_list_items_instances)
    end

    # チェック済みの食材が新規の食材リストに含まれているかチェック
    # 含まれている場合にはチェック済みの食材の数値が変動するため、「requires_attention = true」にします。
    if !groups_without_unchecked.empty?
      requires_attention = merge_and_check_material_groups(groups_without_unchecked, matching_items)
    end

    render json: { requires_attention: requires_attention }
  end

  # 食材リストの食材データにあるチェックボックスをクリックしたら記録するアクション
  def toggle_check
    shopping_list_item = ShoppingListItem.find(params[:id])
    shopping_list_item.update(is_checked: params[:is_checked])
  end

  private

  # 食材リストデータが空の場合に、既存の食材リストの中にチェックが入った食材があれば、
  # 「確認ダイヤログ」を出す指示を出す。なければ関連データを削除して食材リストをリセット
  def handle_empty_cart_items(shopping_list)
    if shopping_list.shopping_list_items.where(is_checked: true).exists?
      render json: { requires_attention: true }
    else
      # ショッピングリスト内のアイテムとメニューを全て削除
      shopping_list.shopping_list_items.delete_all
      shopping_list.shopping_list_menus.delete_all

      render json: { requires_attention: false }
    end
  end

  def ensure_cart_is_not_empty
    if current_user_cart.cart_items.empty?
      flash[:error] = "献立を選択してください。"
      redirect_to root_path
    end
  end

end