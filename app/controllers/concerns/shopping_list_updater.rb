module ShoppingListUpdater

  def reset_and_create_shopping_list_items(shopping_list, shopping_list_items_instances, menu_item_counts)
    #既存のショッピングリストアイテムとメニューを削除
    shopping_list.shopping_list_items.delete_all
    shopping_list.shopping_list_menus.delete_all

    #新しいショッピングリストアイテムをデータベースに保存
    shopping_list_items_instances.each do |item_instance|
      item_instance.save!
    end

    #メニュー項目ごとの数量に基づいて、ショッピングリストメニューを作成
    menu_item_counts.each do |menu_id, item_count|
      shopping_list.shopping_list_menus.create!(
        menu_id: menu_id,
        menu_count: item_count
      )
    end
  end


  # 各アイテムの変換後の数量を計算
  def convert_to_default_unit(quantity, conversion_factor)
    quantity * conversion_factor
  end


  # このメソッドは、指定された材料名に基づいてデフォルト単位の変換係数を返します。
  def get_conversion_factor_by_material_id(material_id, unit_id)
    # Material オブジェクトの default_unit_id に基づいて、
    # MaterialUnit モデルから変換係数を取得
    material_unit = MaterialUnit.find_by(material_id: material_id, unit_id: unit_id)
    material_unit.conversion_factor
  end


  # チェック済みの食材データが、新たに更新する食材データに含まれている場合にデータを取得
  def find_matching_items(checked_items, shopping_list_items_instances)
    # 共通の material_id を持つアイテムのペアを格納する配列
    matching_items = []
    # checked_items（チェック済みアイテム）とshopping_list_items_instances（新しいアイテム）を比較
    checked_items.each do |checked_item|
      shopping_list_items_instances.each do |new_item|
        if checked_item.material_id == new_item.material_id
          # material_id が一致するアイテムのペアを見つけた場合、配列に追加
          matching_items << { checked_item: checked_item, new_item: new_item }
        end
      end
    end
    matching_items
  end


  def create_shopping_list_items(aggregated_ingredients, shopping_list)
    # 材料ごとのカテゴリIDを格納するためのハッシュマップを初期化
    ingredients_with_categories = {}

    # 各集約された材料に対してカテゴリIDを取得
    aggregated_ingredients.each do |ingredient|
      material = Material.find_by(id: ingredient.material_id)
      ingredients_with_categories[ingredient.material_id] = material.category_id
    end

    # 集約された材料リストからShoppingListItemのインスタンスを作成
    aggregated_ingredients.map do |ingredient|
      shopping_list.shopping_list_items.new(
        material_id: ingredient.material_id,
        quantity: ingredient.quantity,
        unit_id: ingredient.unit_id,
        category_id: ingredients_with_categories[ingredient.material_id],
        is_checked: false
      )
    end
  end


  def aggregate_and_update_checked_items(checked_items)
    # checked_itemsの中にmaterial_idが重複している組み合わせをそれぞれmaterial_idごとにグレープ化
    grouped_checked_items = checked_items.group_by(&:material_id)
    min_items_to_process = @settings.dig('limits', 'min_items_to_process')

    if grouped_checked_items.present?
      grouped_checked_items.each do |material_id, items|
        # アイテムが1つしかない場合、処理をスキップして次のイテレーションへ
        next if items.size <= min_items_to_process

        # 各アイテムごとの変換後の数量の合計を計算
        total_quantity = items.reduce(0) do |sum, item|
          # 各アイテムに対して変換率を取得
          conversion_factor = get_conversion_factor_by_material_id(material_id, item.unit_id)
          # アイテムの数量をデフォルトの単位に変換
          converted_quantity = convert_to_default_unit(item.quantity, conversion_factor)
          # 変換後の数量を合計に加算
          sum + converted_quantity
        end

        material = Material.find_by(id: material_id)
        # MaterialUnit からデフォルトの unit_id を取得
        default_unit = MaterialUnit.find_by(material_id: material.id, unit_id: material.default_unit_id)

        # 合算したインスタンスの作成
        aggregated_item = ShoppingListItem.new(
          shopping_list_id: items.first.shopping_list_id,
          material_id: material_id,
          quantity: total_quantity,
          unit_id: default_unit.unit_id,
          category_id: items.first.category_id,
          is_checked: true
        )

        # ここで既存のアイテムを削除
        items.each(&:destroy)

        # 新しいaggregated_itemを保存
        aggregated_item.save
      end
    end
  end


  # カート内のアイテムから献立IDと数量のハッシュを生成するメソッド
  def get_menu_item_counts(cart_items)
    # 献立とその数量を取得
    # 具体的にはmenu_idとそのitem_countだけをハッシュとして取得
    #例： {チキンカレーのmenu_id => 2, サラダのmenu_id => 1}
    cart_items.each_with_object({}) do |cart_item, counts|
      counts[cart_item.menu_id] = cart_item.item_count
    end
  end


  # カート内のアイテムに基づいて必要な食材を取得し、それらを必要な量だけ複製するメソッド
  def duplicate_ingredients_for_menu(cart_items, menu_item_counts)
    # 献立に使う食材データを取得
    menu_ingredients = cart_items.flat_map { |cart_item| cart_item.menu.menu_ingredients }

    # 献立の数量に合わせて食材数を倍にする
    ingredients_duplicated = []
    menu_ingredients.each do |menu_ingredient|
      # 食材の倍数を取得
      menu_count = menu_item_counts[menu_ingredient.menu_id]

      # menu_count分だけレコードを複製
      menu_count.times do
        duplicated_ingredient = menu_ingredient.dup
        ingredients_duplicated << duplicated_ingredient
      end
    end

    ingredients_duplicated
  end


  def process_shopping_list(shopping_list, matching_items, shopping_list_items_instances, menu_item_counts)
    # matching_items から全ての material_id を抽出
    matching_material_ids = matching_items.map { |item| item[:checked_item].material_id }

    # matching_material_ids に含まれない material_id を持つアイテムを全て削除
    shopping_list.shopping_list_items.where.not(material_id: matching_material_ids).delete_all

    matching_items.each do |item|
      checked_item = item[:checked_item]
      new_item = item[:new_item]

      # MaterialUnit モデルから conversion_factor を取得
      checked_conversion_factor = get_conversion_factor_by_material_id(checked_item.material_id, checked_item.unit_id)
      new_conversion_factor = get_conversion_factor_by_material_id(new_item.material_id, new_item.unit_id)

      # 同じ単位に変換（デフォルトで設定している単位に変換）
      checked_quantity_converted = convert_to_default_unit(checked_item.quantity, checked_conversion_factor)
      new_quantity_converted = convert_to_default_unit(new_item.quantity, new_conversion_factor)

      # 食材数が既存データよりも少なくなる場合
      if checked_quantity_converted > new_quantity_converted
        # 新しい食材の数量を計算し、小数点第2位を繰り上げ
        adjusted_quantity = (new_quantity_converted / new_conversion_factor).ceil(1)
        # 既存データの数量を新しい食材の数量に差し替え、かつ
        checked_item.update(quantity: adjusted_quantity, unit_id: new_item.unit_id, is_checked: true)
        # 既存データを更新したため、新規で作成されているインスタンスデータは削除
        shopping_list_items_instances.delete(new_item)

      # 食材数が既存データよりも多くなる場合
      elsif checked_quantity_converted < new_quantity_converted
        additional_quantity = ((new_quantity_converted - checked_quantity_converted) / new_conversion_factor).ceil(1)
        shopping_list_items_instances.find { |i| i == new_item }.quantity = additional_quantity

      # 食材数が既存データと同じ場合
      elsif checked_quantity_converted == new_quantity_converted
        shopping_list_items_instances.delete(new_item)
      end
    end

    # 残りのアイテムを保存
    shopping_list_items_instances.each(&:save!)

    # 既存の shopping_list_menus レコードを削除
    shopping_list.shopping_list_menus.delete_all

    # メニュー項目ごとの数量に基づいて、ショッピングリストメニューを作成
    menu_item_counts.each do |menu_id, item_count|
      shopping_list.shopping_list_menus.create!(menu_id: menu_id, menu_count: item_count)
    end
  end


  def group_related_items_by_material_id(checked_items, shopping_list_id)
    # checked_items からすべての material_id を抽出
    checked_material_ids = checked_items.pluck(:material_id)
    # checked_material_ids に紐づくすべての ShoppingListItem を取得
    related_items = ShoppingListItem.where(shopping_list_id: shopping_list_id, material_id: checked_material_ids)
    # idごとにグループ化
    related_items.group_by(&:material_id)
  end


  def compare_unchecked_and_new_items(groups_with_unchecked_only, shopping_list_items_instances)
    requires_attention = false

    # 新しいデータと既存データ（チェック未データ）をmaterial_idごとに格納
    unchecked_material_groups = {}
    groups_with_unchecked_only.each do |material_id, unchecked_items|
      # 新規データ項目を取得
      new_items = shopping_list_items_instances.select { |item| item.material_id == material_id }
      # 既存のデータ（unchecked_items）と新規データ（new_items）をハッシュに格納
      unchecked_material_groups[material_id] = {
        existing_items: unchecked_items,
        new_items: new_items
      }
    end

    unchecked_material_groups.each do |material_id, items_group|
      existing_item = items_group[:existing_items].first
      new_item = items_group[:new_items].first

      # 既存データまたは新規データが nil の場合は次のループへ
      next if existing_item.nil? || new_item.nil?

      # unit_id が一致するか確認
      quantity_difference = if existing_item.unit_id == new_item.unit_id
        # quantity の差分を計算
        existing_item.quantity - new_item.quantity
      end

      # unit_id が一致する場合の処理
      # quantity_difference が存在し、かつ0未満の場合は処理を終了
      if quantity_difference.present? && quantity_difference < 0
        requires_attention = true
        return
      # quantity_difference が存在するが0未満ではない場合はループをスキップ
      elsif quantity_difference.present?
        next
      end

      # unit_id が一致しない場合の処理
      # MaterialUnit モデルから conversion_factor を取得
      existing_item_conversion_factor = get_conversion_factor_by_material_id(existing_item.material_id ,existing_item.unit_id)
      new_item_conversion_factor = get_conversion_factor_by_material_id(new_item.material_id, new_item.unit_id)

      # 同じ単位系に変換
      existing_quantity_converted = convert_to_default_unit(existing_item.quantity, existing_item_conversion_factor)
      new_quantity_converted = convert_to_default_unit(new_item.quantity, new_item_conversion_factor)

      if existing_quantity_converted > new_quantity_converted
        requires_attention = true
        break
      end
    end

    requires_attention
  end


  def merge_and_check_material_groups(groups_without_unchecked, matching_items)
    checked_material_groups = {}

    groups_without_unchecked.each do |material_id, unchecked_items|
      # matching_items から一致する material_id のデータを取得
      matching_new_items = matching_items.select do |item|
        item[:new_item].material_id == material_id
      end

      # :new_item を抽出して新しい配列を作成
      matching_new_items = matching_new_items.map { |item| item[:new_item] }

      # 既存のデータ（unchecked_items）と一致する新規データ（matching_new_items）をハッシュに格納
      checked_material_groups[material_id] = {
        existing_items: unchecked_items,
        new_items: matching_new_items
      }
    end

    # checked_material_groups が空でない場合、注意が必要
    !checked_material_groups.blank?
  end


  def update_shopping_list
    begin
      ActiveRecord::Base.transaction do
        # カートの中にあるmenu_idとその個数のデータを取得
        cart_items = current_user_cart.cart_items
        # ショッピングリストを取得または作成
        shopping_list = current_user_cart.shopping_list || current_user_cart.create_shopping_list
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

        # 該当するデータがない場合、既存のアイテムを削除し新規に作成
        if !shopping_list.shopping_list_items.where(is_checked: true).exists?
          reset_and_create_shopping_list_items(shopping_list, shopping_list_items_instances, menu_item_counts)
        end

        # is_checked: true のレコードを直接データベースから取得
        checked_items = ShoppingListItem.where(shopping_list_id: shopping_list.id, is_checked: true)
        # find_matching_items メソッドを呼び出して一致するアイテムのペアを取得
        matching_items = find_matching_items(checked_items, shopping_list_items_instances)

        if !matching_items.empty?
          # checked_items と shopping_list_items_instances のデータを処理
          process_shopping_list(shopping_list,matching_items, shopping_list_items_instances, menu_item_counts)
        end

      end
    rescue ActiveRecord::RecordInvalid
      handle_general_error
      return
    end
  end
end
