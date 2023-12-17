class CartItemsController < ApplicationController

  def create
    # 現在のユーザーのカートを取得または新規作成
    cart = current_user.cart || current_user.create_cart

    # 各モデルからのアイテム数の総計を取得
    total_items_count = total_items_count(cart)
    max_total_items = @settings.dig('limits', 'max_total_items')

    # 総数が20個を超えている場合の処理
    if total_items_count >= max_total_items
      flash[:error] = "献立の登録上限に達しました。"
      redirect_back(fallback_location: root_path) and return
    end

    # カート内の同じmenu_idのアイテムを検索
    cart_item = cart.cart_items.find_by(menu_id: params[:menu_id])

    if cart_item
      # 同じmenu_idのアイテムが存在する場合、数量を1増やす
      cart_item.increment!(:item_count)
    else
      # 新しいカートアイテムの作成、数量はデフォルトで1とする
      item_count = @settings.dig('defaults', 'item_count')
      cart.cart_items.create(menu_id: params[:menu_id], item_count: params[:item_count])
    end

    flash[:notice] = "献立を選択しました。"
    redirect_to root_path
  end


  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy

    redirect_back(fallback_location: root_path)
  end


  def increment
    cart_item = CartItem.find_by(id: params[:id])
    cart_item.increment!(:item_count)
    redirect_back(fallback_location: root_path)
  end


  def decrement
    cart_item = CartItem.find_by(id: params[:id])
    cart_item.decrement!(:item_count) if cart_item.item_count > 1
    redirect_back(fallback_location: root_path)
  end

  private

  # このメソッドは、ユーザーが関連するCompletedMenu、ShoppingListMenu、
  # およびCartItemモデルからの総アイテム数を計算します。
  def total_items_count(cart)
    # ユーザーに関連するCompletedMenuモデルのアイテム数を計算
    completed_menus_count = CompletedMenu.where(user_id: current_user.id).count

    # ユーザーのカートに関連するShoppingListMenuモデルのアイテム数を計算
    shopping_list_menus_count = ShoppingListMenu.where(shopping_list_id: cart.shopping_list&.id).count

    # カート内のCartItemモデルのアイテム数を計算
    cart_items_count = cart.cart_items.count

    # 3つのモデルからの総アイテム数を合計して返す
    completed_menus_count + shopping_list_menus_count + cart_items_count
  end
end
