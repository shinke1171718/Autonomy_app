class CompletedMenusController < ApplicationController
  include IngredientsAggregator

  def index
    # 買い出しが完了した食材データを取得
    @completed_menus = CompletedMenu.where(user_id: current_user.id)

    # 買い物完了したメニューがない場合、献立選択画面にリダイレクト
    redirect_to root_path if @completed_menus.empty?
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


  def show
    @menu = Menu.find(params[:menu_id])

    # 重複した献立を基準の単位に変換し、合算する
    menu_ingredients = MenuIngredient.where(menu_id: @menu.id)
    ingredients = menu_ingredients.includes(:ingredient).map(&:ingredient)

    # menuの個数を格納
    @serving_size = params[:menu_count].to_i

    aggregated_ingredients = aggregate_ingredients(ingredients)

    # scale_ingredientsメソッドを呼び出して、quantityを更新
    @scaled_ingredients = scale_ingredients(aggregated_ingredients, @serving_size)
  end

  private

  # ingredientsのquantityをmenu_countの累乗で更新するメソッド
  def scale_ingredients(ingredients, menu_count)
    menu_count = menu_count.to_i

    ingredients.map do |ingredient|
      # 各ingredientのクローンを作成
      new_ingredient = ingredient.dup

      # quantityをmenu_countの累乗で更新
      new_ingredient.quantity *= menu_count

      new_ingredient
    end
  end

end
