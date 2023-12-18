class CompletedMenusController < ApplicationController
  include IngredientsAggregator
  include ServingSizeHandler
  include IngredientScaler

  def index
    # 買い出しが完了した食材データを取得
    @completed_menus = CompletedMenu.where(user_id: current_user.id, is_completed: false)

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

        shopping_list_menus.each do |menu|
          # 既存のCompletedMenuレコードを検索する
          # 条件は、現在のユーザー（current_user.id）が持つ、まだ完了していない（is_completed: false）特定のメニュー（menu.menu_id）
          completed_menu = CompletedMenu.find_by(menu_id: menu.menu_id, user_id: current_user.id, is_completed: false)

          if completed_menu
            # CompletedMenuモデルに同じ献立がある場合にはmenu_countを更新するように設定
            completed_menu.update!(menu_count: completed_menu.menu_count + menu.menu_count)
          else
            # CompletedMenuモデルに同じデータがない場合は、completed_menusデータを作成
            current_user.completed_menus.create!(
              menu_id: menu.menu_id,
              menu_count: menu.menu_count,
              is_completed: false,
            )
          end
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
    aggregated_ingredients = aggregate_ingredients(ingredients)

    # scale_ingredientsメソッドを呼び出して、quantityを更新
    @scaled_ingredients = scale_ingredients(aggregated_ingredients, @serving_size)
  end


  def mark_as_completed
    # ActiveRecord::Relationオブジェクトのため「first」でデータを取得
    menu_to_update = CompletedMenu.find_by(menu_id: params[:menu_id], user_id: current_user.id, is_completed: false)

    # 作った献立の数を取得
    serving_size = params[:serving_size].to_i

    # 買い出しした献立数を変数に格納
    purchased_menu_count = menu_to_update.menu_count

    # 「買い出しした献立数」より「作った献立」が少ない場合の処理
    if serving_size < purchased_menu_count
      begin
        ActiveRecord::Base.transaction do
          # 新しい数量でレコードを複製
          completed_menu = menu_to_update.dup
          # データを作った献立データとして再設定
          completed_menu.update!(menu_count: serving_size, is_completed: true, date_completed: Time.current)
          # 元のレコードを新しい数量を引いた値で更新
          menu_to_update.update!(menu_count: purchased_menu_count - serving_size)
        end
      rescue ActiveRecord::RecordInvalid => e
        handle_general_error(e)
        return
      end

    else
      # 「買い出しした献立数」と「作った献立」が同じ場合の処理
      menu_to_update.update!(is_completed: true, date_completed: Time.current)
    end

    flash[:notice] = "献立の調理完了です。お疲れ様でした！"
    redirect_to completed_menus_path
  end
end
