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

    flash[:notice] = "調理が完了し、選択したレシピがリセットされました。"
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
    processed_results = {}
    no_quantity_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id')
    # menu_idごとのデータを格納するハッシュを初期化
    duplicate_ingredients = duplicate_ingredients(menu_ingredients, menu_item_counts)
    # 各menu_idごとに「特殊なunit_id」と「それ以外」のデータを分けて格納する
    categorized_ingredients = duplicate_ingredients.each_with_object({}) do |(menu_id, ingredients), result|
      # 特殊なunit_id（例: 17）のデータとそれ以外のデータを分ける
      special_unit_ids, other_units = ingredients.partition { |ingredient| ingredient.unit_id == no_quantity_unit_id }

      # 分けたデータをそれぞれ配列に格納し、menu_idごとのハッシュに追加
      result[menu_id] = {
        "special_unit_ids" => special_unit_ids,
        "other_units" => other_units
      }
    end

    categorized_ingredients.each do |menu_id, categories|
      # menu_idに対応するmenu_nameを取得
      menu = Menu.find(menu_id)
      menu_name = menu.menu_name
      processed_results[menu_name] ||= []

      # "special_unit_ids" の処理
      special_units_processed = categories["special_unit_ids"].group_by(&:material_name).map do |_, ingredients|
        ingredients.first
      end

      # "other_units" の処理: ここでは例として同じ material_name の quantity を合算する簡単な例を示します
      other_units_processed = cooking_flows_aggregate_ingredients(categories["other_units"])

      # 処理結果を menu_id ごとの配列に統合
      processed_results[menu_name].concat(special_units_processed + other_units_processed)
    end

    processed_results
  end

  def duplicate_ingredients(menu_ingredients, menu_item_counts)
    # menu_idごとに複製されたingredientsを格納するハッシュを初期化
    grouped_ingredients = {}
    default_menu_item_count = @settings.dig('limits', 'default_menu_item_count')

    # 各menu_ingredientに対して処理を実行
    menu_ingredients.each do |menu_ingredient|
      menu_id = menu_ingredient.menu_id
      ingredient = menu_ingredient.ingredient
      # 該当するmenu_idのmenu_item_countsを取得、存在しない場合は0とする
      count = menu_item_counts[menu_id] || default_menu_item_count

      # menu_idキーがまだ存在しない場合は、空の配列を作成
      grouped_ingredients[menu_id] ||= []

      # menu_item_countsの数だけingredientを複製し、配列に追加
      count.times do
        # ここではシンプルな複製を想定していますが、実際にはdeep copyが必要な場合があります
        duplicated_ingredient = ingredient.dup
        # quantityの計算を行い、複製したingredientに設定
        duplicated_ingredient.quantity = ingredient.quantity ? ingredient.quantity * count : nil

        # 複製したingredientをgrouped_ingredientsに追加
        grouped_ingredients[menu_id] << duplicated_ingredient
      end
    end

    grouped_ingredients
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
