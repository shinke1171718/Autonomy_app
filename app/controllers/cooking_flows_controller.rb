class CookingFlowsController < ApplicationController
  include CartChecker
  before_action :ensure_cart_is_not_empty

  def index
    # cooking_flowがある場合は取得し、ない場合は新規作成
    @cooking_flow = CookingFlow.find_or_create_by(cart_id: current_user.cart.id)

    # カートに含まれるメニューIDを取得し、メニューIDに紐づくレシピステップをmenu_idごとにグループ化
    recipe_steps_by_menu = fetch_recipe_steps_by_menu
    # 引数で渡されたレシピステップのグループからCookingStepインスタンスを生成
    cooking_steps = build_cooking_steps(recipe_steps_by_menu, @cooking_flow.id)
    # レシピステップカテゴリIDに基づいて分類し、指定された順序（野菜の下準備、その他の下準備、肉の下準備）で並び替え
    sorted_steps = sort_cooking_steps(cooking_steps)

    cart_items = current_user_cart.cart_items
    # メニューデータを取得
    @menus = cart_items.includes(menu: [:image_attachment]).map(&:menu).uniq
    # CartItemモデルのデータからメニューアイテムのカウントを取得
    @menu_item_counts = cart_items.each_with_object({}) do |cart_item, counts|
      counts[cart_item.menu_id] = cart_item.item_count
    end

    # カートアイテムから食材IDを取得
    cart_item_ids = cart_items.pluck(:menu_id)
    # menu_idからmenu_nameを取得できる
    menus = Menu.where(id: cart_item_ids).index_by(&:id)
    # 全てのUnitを事前に取得しておく
    units = Unit.all.index_by(&:id)

    # sorted_stepsを用いて、各ステップに関連する詳細情報を取得
    @cooking_steps_with_menu_name = build_cooking_steps_with_details(sorted_steps)

    # MenuIngredientからingredient_idを取得し、関連するテーブルデータを全て取得
    menu_ingredients = MenuIngredient.includes(:ingredient).where(menu_id: cart_item_ids)

    # ingredientデータの構築
    @ingredients = build_ingredients_data(menu_ingredients, menus, units, @menu_item_counts)
  end

  def complete
    cooking_flow = CookingFlow.find(params[:id])

    ActiveRecord::Base.transaction do
      cart = cooking_flow.cart
      cart.destroy!
    end

    flash[:notice] = "調理が完了し、選択した献立がリセットされました。"
    redirect_to root_path

  rescue ActiveRecord::RecordNotDestroyed => e
    flash[:error] = "データの削除中にエラーが発生しました。"
    redirect_to cooking_flows_path
  end


  private

  # 現在のユーザーのカートに含まれるメニューIDを取得し、それらのメニューIDに紐づくレシピステップを
  # メニューIDごとにグループ化して取得します。
  def fetch_recipe_steps_by_menu
    menu_ids = current_user_cart.cart_items.pluck(:menu_id).uniq
    RecipeStep.where(menu_id: menu_ids).group_by(&:menu_id)
  end

  # 引数で渡されたレシピステップのグループからCookingStepインスタンスを生成します。
  # 各CookingStepには、対応するcooking_flow_id, recipe_step_id, menu_name,
  # およびrecipe_step_category_idが含まれます。
  def build_cooking_steps(recipe_steps_by_menu, cooking_flow_id)
    cooking_steps = []
    recipe_steps_by_menu.each do |menu_id, recipe_steps|
      menu_name = Menu.find(menu_id).menu_name
      recipe_steps.each do |recipe_step|
        cooking_steps << CookingStep.new(
          cooking_flow_id: cooking_flow_id,
          recipe_step_id: recipe_step.id,
          menu_name: menu_name,
          recipe_step_category_id: recipe_step.recipe_step_category_id
        )
      end
    end
    cooking_steps
  end

  # 生成されたCookingStepインスタンスを、レシピステップカテゴリIDに基づいて分類し、
  # 指定された順序（野菜の下準備、その他の下準備、肉の下準備）で並び替えます。
  # recipe_step_category_idが1, 2, 3以外のものは、指定された順序の後に追加されます。
  def sort_cooking_steps(cooking_steps)
    categories = @settings.dig('recipe_step_categories')
    vegetable_prep_steps = cooking_steps.select { |step| step.recipe_step.recipe_step_category_id == categories['vegetable_prep'] }
    meat_prep_steps = cooking_steps.select { |step| step.recipe_step.recipe_step_category_id == categories['meat_prep'] }
    other_prep_steps = cooking_steps.select { |step| step.recipe_step.recipe_step_category_id == categories['other_prep'] }
    other_steps = cooking_steps.reject { |step| [categories['vegetable_prep'], categories['meat_prep'], categories['other_prep']].include?(step.recipe_step.recipe_step_category_id) }
  
    sorted_steps = vegetable_prep_steps + other_prep_steps + meat_prep_steps + other_steps
    sorted_steps
  end

  # ingredientデータの構築
  def build_ingredients_data(menu_ingredients, menus, units, menu_item_counts)
    grouped_ingredients = menu_ingredients.each_with_object({}) do |menu_ingredient, grouped|
      menu_id = menu_ingredient.menu_id
      ingredient = menu_ingredient.ingredient
      menu_name = menus[menu_id].menu_name
      unit_name = units[ingredient.unit_id].unit_name

      # 食材の量をメニュー項目ごとのカウントに基づいて調整
      quantity = ingredient.quantity * menu_item_counts[menu_id]

      # メニューIDごとに食材データを集約
      grouped[menu_id] ||= {menu_name: menu_name, ingredients: []}
      grouped[menu_id][:ingredients] << {ingredient: ingredient, quantity: quantity, unit_name: unit_name}
    end

    # メニューIDごとに集約したデータを配列に変換して返す
    grouped_ingredients.map do |menu_id, data|
      {
        menu_id: menu_id,
        menu_name: data[:menu_name],
        ingredients: data[:ingredients]
      }
    end
  end


  # 作り方に関するインスタンスデータから各データに関連するRecipeStepの情報とmenu_nameを取得し、
  # それらをハッシュの配列として整理するメソッド
  def build_cooking_steps_with_details(sorted_steps)
    sorted_steps.map do |step|
      # RecipeStepと関連するカテゴリを予め読み込み
      recipe_step = RecipeStep.includes(:recipe_step_category).find(step.recipe_step_id)
      menu_id = recipe_step.menu_id
      # Menuの名前を取得
      menu_name = Menu.find(menu_id).menu_name

      # 必要な情報をハッシュとして組み立てる
      {
        step: step,
        recipe_step: recipe_step,
        menu_name: menu_name
      }
    end
  end
end
