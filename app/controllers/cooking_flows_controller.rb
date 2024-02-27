class CookingFlowsController < ApplicationController
  include CartChecker
  include MenuItemCounts
  before_action :ensure_cart_is_not_empty

  def index
    # cooking_flowがある場合は取得し、ない場合は新規作成
    @cooking_flow = CookingFlow.find_or_create_by(cart_id: current_user.cart.id)

    # 引数で渡されたレシピステップのグループからCookingStepインスタンスを生成
    cooking_steps = build_cooking_steps(@cooking_flow.id)

    # レシピステップカテゴリIDに基づいて分類し、指定された順序（野菜の下準備、その他の下準備、肉の下準備）で並び替え
    sorted_steps = sort_cooking_steps(cooking_steps)

    # sorted_stepsを用いて、各ステップに関連する詳細情報を取得
    @cooking_steps_with_menu_name = build_cooking_steps_with_details(sorted_steps)

    @menus = cart_items.includes(menu: [:image_attachment]).map(&:menu).uniq

    # CartItemモデルのデータからメニューアイテムのカウントを取得
    @menu_item_counts = calculate_menu_item_counts(cart_items)

    # ingredientデータの構築
    @ingredients = build_ingredients_data(@menu_item_counts)
  end

  def complete
    current_user_cart.destroy!

    flash[:notice] = "調理が完了し、選択したレシピがリセットされました。"
    redirect_to root_path

  rescue ActiveRecord::RecordNotDestroyed => e
    flash[:error] = "データの削除中にエラーが発生しました。"
    redirect_to cooking_flows_path
  end


  private

  # 引数で渡されたレシピステップのグループからCookingStepインスタンスを生成します。
  # 各CookingStepには、対応するcooking_flow_id, recipe_step_id, menu_name,
  # およびrecipe_step_category_idが含まれます。
  def build_cooking_steps(cooking_flow_id)
    # カートに含まれるメニューIDを取得し、メニューIDに紐づくレシピステップをmenu_idごとにグループ化
    recipe_steps_by_menu = RecipeStep.where(menu_id: cart_items.pluck(:menu_id).uniq).group_by(&:menu_id)

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
    vegetable_prep_steps, meat_prep_steps, other_prep_steps, other_steps = [], [], [], []

    cooking_steps.each do |step|
      case step.recipe_step.recipe_step_category_id
      when categories['vegetable_prep']
        vegetable_prep_steps << step
      when categories['meat_prep']
        meat_prep_steps << step
      when categories['other_prep']
        other_prep_steps << step
      else
        other_steps << step
      end
    end

    sorted_steps = vegetable_prep_steps + other_prep_steps + meat_prep_steps + other_steps
    sorted_steps
  end

  # ingredientデータの構築
  def build_ingredients_data(menu_item_counts)
    cart_item_ids = cart_items.pluck(:menu_id)

    # Menu、MenuIngredient、およびIngredientを事前にロード
    menus_with_ingredients = Menu.includes(menu_ingredients: :ingredient).where(id: cart_item_ids)

    # MenuIngredientからingredient_idを取得し、関連するテーブルデータを全て取得
    menu_ingredients = MenuIngredient.includes(:ingredient).where(menu_id: cart_item_ids)

    processed_results = {}
    no_quantity_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id')

    menus_with_ingredients.each do |menu|

      special_unit_ids = []
      other_units = []

      menu.menu_ingredients.each do |menu_ingredient|
        ingredient = menu_ingredient.ingredient

        # ingredient.unit_idがno_quantity_unit_idと等しいかどうかをチェック
        if ingredient.unit_id == no_quantity_unit_id
          special_unit_ids << ingredient
        else
          other_units << ingredient
        end
      end

      menu_name = menu.menu_name
      processed_results[menu_name] ||= []

      special_units_processed = special_unit_ids.group_by(&:material_name).map do |_, ingredients|
        ingredients.first
      end

      other_units_processed = cooking_flows_aggregate_ingredients(other_units)
      processed_results[menu_name].concat(special_units_processed + other_units_processed)
    end

    processed_results
  end

  def cooking_flows_aggregate_ingredients(ingredient_list)
    min_duplicate_count = @settings.dig('limits', 'min_duplicate_count')
    aggregated_ingredients = []

    # material_idに基づいてグループ化
    grouped_ingredients = ingredient_list.group_by(&:material_id)

    grouped_ingredients.each do |material_id, ingredients_group|
      # 重複していない食材の処理
      if ingredients_group.length <= min_duplicate_count
        aggregated_ingredients << ingredients_group.first
        next
      end

      material = Material.find_by(id: material_id)
      material_name = material.material_name
      # 重複している食材の処理
      total_quantity, unit_id_to_use = cooking_flows_aggregate_quantities(ingredients_group)

      # 「material_id」、合算した「数量」、「デフォルト単位」を１つのインスタンスとして再構成
      aggregated_ingredient = Ingredient.new(
        material_name: material_name,
        material_id: material_id,
        quantity: total_quantity,
        unit_id: unit_id_to_use
      )

      aggregated_ingredients << aggregated_ingredient
    end

    aggregated_ingredients
  end

  # 食材が重複した場合、「MaterialUnit」にある"変換率"をかけて合算し、
  # 「Material」にある"デフォルトのunit_id"を単位に設定する
  def cooking_flows_aggregate_quantities(grouped_ingredients)

    # 複数の食材の合算数値
    total_quantity = @settings.dig('limits', 'total_quantity').to_i
    exception_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id').to_i
    exception_ingredient_quantity = @settings.dig('ingredient', 'exception_ingredient_quantity')

    # グループ内で使用されている全てのunit_idを取得
    filtered_unit_ids = grouped_ingredients.map(&:unit_id).uniq
    unique_unit_id_threshold = @settings.dig('limits', 'unique_unit_id_threshold')

    # グループ内で使用されている全てのunit_idが同じかどうかを確認
    is_same_unit_id = filtered_unit_ids.length == unique_unit_id_threshold

    # 使用するunit_idを決定
    unit_id_to_use = if is_same_unit_id
      grouped_ingredients.first.unit_id
    else
      grouped_ingredients.first.material.default_unit_id
    end

    # 同じunit_idである場合と異なる場合で合算ロジックを分ける
    if is_same_unit_id
      # グループ内のunit_idが全て同じでその単位で合算
      total_quantity = grouped_ingredients.sum(&:quantity)
    else
      # 異なるunit_idが存在する場合、materialのdefault_unit_idを使用して合算
      total_quantity = grouped_ingredients.reduce(0) do |sum, ingredient|
        material_unit = MaterialUnit.find_by(material_id: ingredient.material_id, unit_id: ingredient.unit_id)
        conversion_factor = material_unit.conversion_factor
        quantity = ingredient.quantity || exception_ingredient_quantity
        sum + quantity * conversion_factor
      end
    end

    [total_quantity, unit_id_to_use]
  end

  # 作り方に関するインスタンスデータから各データに関連するRecipeStepの情報とmenu_nameを取得し、
  # それらをハッシュの配列として整理するメソッド
  def build_cooking_steps_with_details(sorted_steps)
    # sorted_stepsからmenu_nameを取得し、それを基にユニークなmenu_idを直接取得
    menu_ids = Menu.where(menu_name: sorted_steps.map(&:menu_name).uniq).pluck(:id)

    # menu_idに紐づく全てのRecipeStepデータを一度に取得
    recipe_steps = RecipeStep.includes(:recipe_step_category).where(menu_id: menu_ids)

    sorted_steps.map do |step|
      # sorted_stepのrecipe_step_idに一致するRecipeStepオブジェクトを検索
      recipe_step = recipe_steps.find { |rs| rs.id == step.recipe_step_id }

      # Menuの名前を取得
      menu_name = step.menu_name

      # 必要な情報をハッシュとして組み立てる
      {
        menu_name: menu_name,
        recipe_step: recipe_step
      }
    end
  end
end
