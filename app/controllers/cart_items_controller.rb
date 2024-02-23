class CartItemsController < ApplicationController
  include IngredientsAggregator
  include ShoppingListUpdater

  def create
    # 現在のユーザーのカートを取得または新規作成
    cart = current_user_cart || current_user.create_cart

    # 各モデルからのアイテム数の総計を取得
    shopping_list_menus_count = ShoppingListMenu.where(shopping_list_id: cart.shopping_list&.id).count
    max_total_items = @settings.dig('limits', 'max_total_items')

    # 総数が20個を超えている場合の処理
    if shopping_list_menus_count >= max_total_items
      flash[:error] = "選択できる上限に達しました。"
      redirect_back(fallback_location: root_path) and return
    end

    # カート内の同じmenu_idのアイテムを検索
    cart_item = cart_items.find_by(menu_id: params[:menu_id])

    if cart_item
      # 同じmenu_idのアイテムが存在する場合、params[:serving_size]の値だけ数量を増やす
      additional_count = params[:serving_size].to_i
      cart_item.increment!(:item_count, additional_count)
    else
      # 新しいカートアイテムの作成、数量はデフォルトで1とする
      item_count = @settings.dig('defaults', 'item_count')
      cart_items.create(menu_id: params[:menu_id], item_count: params[:serving_size])
    end

    flash[:notice] = "レシピを選択しました。"
    redirect_to root_path
  end


  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy

    shopping_list = current_user_cart.shopping_list

    # カート内のアイテムが空になったかチェック
    if cart_items.empty?
      # ショッピングリスト内のアイテムとメニューを全て削除
      shopping_list_items.delete_all
      shopping_list_items.delete_all
    else
      update_shopping_list
    end

    redirect_back(fallback_location: root_path)
  end


  def increment
    cart_item = CartItem.find_by(id: params[:id])

    max_item_count = @settings.dig('limits', 'default_max_serving_size')
    # item_countが10以上の場合は処理を終了する
    return if cart_item.item_count >= max_item_count

    cart_item.increment!(:item_count)
    redirect_back(fallback_location: root_path)
  end


  def decrement
    cart_item = CartItem.find_by(id: params[:id])
    min_items_to_decrement = @settings.dig('limits', 'min_items_to_decrement')

    if cart_item.item_count > min_items_to_decrement
      cart_item.decrement!(:item_count)
      update_shopping_list
    end

    respond_to do |format|
      format.js { render partial: 'users/quantity', locals: { cart_item: cart_item } }
    end
  end
end
