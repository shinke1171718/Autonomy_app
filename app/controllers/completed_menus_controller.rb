class CompletedMenusController < ApplicationController
  include IngredientsAggregator
  before_action :set_serving_sizes, only: [:show, :change_serving_size]

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
    aggregated_ingredients = aggregate_ingredients(ingredients)

    # scale_ingredientsメソッドを呼び出して、quantityを更新
    @scaled_ingredients = scale_ingredients(aggregated_ingredients, @serving_size)
  end


  def change_serving_size
    # increase_servingと同様の理由
    menu_id = params[:id]
    # 減少か増加をするかどうかを判断
    change_type = params[:change_type]
    # 献立の最低数でこれ以上は現状できない数値
    min_serving_size = @settings.dig('limits', 'min_serving_size')

    if change_type == 'increase'
      # 調理する献立の数量を増加
      @serving_size = [@serving_size + 1, @max_serving_size].min
    elsif change_type == 'decrease'
      # 調理する献立の数量を現状
      @serving_size = [@serving_size - 1, min_serving_size].max
    end

    redirect_to completed_menu_path(menu_id: menu_id, serving_size: @serving_size, max_count: @max_serving_size)
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


  private

  # ingredientsのquantityをmenu_countの値分倍増するメソッド
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


  # show, increase_serving, decrease_servingアクションで利用。
  # before_actionで設定され、繰り返しのコードを避けるためにメソッド化。
  def set_serving_sizes
    # 調理する献立の数量
    @serving_size = params[:serving_size].to_i
    # 調理する献立最大数量
    @max_serving_size = params[:max_count].to_i
  end

end
