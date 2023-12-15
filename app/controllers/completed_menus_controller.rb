class CompletedMenusController < ApplicationController

  def index
    # 買い出しが完了した食材データを取得
    @completed_menus = CompletedMenu.where(user_id: current_user.id)
  end

  def create
    # 現在のユーザーのShoppingListMenuからデータを取得
    shopping_list = current_user.cart.shopping_list

    # 現在登録されている買い物リストデータ
    shopping_list_menus = ShoppingListMenu.where(shopping_list_id: shopping_list.id)
    shopping_list_items = shopping_list.shopping_list_items

    begin
      ActiveRecord::Base.transaction do

        # completed_menusデータを作成
        shopping_list_menus.each do |menu|
          current_user.completed_menus.create!(
            user_id: current_user.id,
            menu_id: menu.menu_id,
            menu_count: menu.menu_count,
            is_completed: false,
          )
        end

        # 買い物リストのデータ削除
        shopping_list_menus.delete_all
        shopping_list_items.delete_all
      end
    rescue ActiveRecord::RecordInvalid
      handle_general_error
      return
    end

    redirect_to completed_menus_path
  end

end
