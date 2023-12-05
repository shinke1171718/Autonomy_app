class CartItemsController < ApplicationController

  def create
    # 現在のユーザーのカートを取得または新規作成
    cart = current_user.cart || current_user.create_cart

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
end
