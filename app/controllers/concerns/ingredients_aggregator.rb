module IngredientsAggregator

  private

  #食材データを受け取り、それをmaterial_idに基づいてグループ化し、各グループの食材を集約する
  def aggregate_ingredients(ingredient_list)
    min_duplicate_count = 1
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
      total_quantity = aggregate_quantities(ingredients_group)
      default_unit_id = ingredients_group.first.material.default_unit_id

      # 「material_id」、合算した「数量」、「デフォルト単位」を１つのインスタンスとして再構成
      aggregated_ingredient = Ingredient.new(
        material_name: material_name,
        material_id: material_id,
        quantity: total_quantity,
        unit_id: default_unit_id
      )

      aggregated_ingredients << aggregated_ingredient
    end

    aggregated_ingredients
  end


  # 食材が重複した場合、「MaterialUnit」にある"変換率"をかけて合算し、
  # 「Material」にある"デフォルトのunit_id"を単位に設定する
  def aggregate_quantities(grouped_ingredients)

    # 複数の食材の合算数値
    total_quantity = 0
    # 合算時に使用する単位を取得
    default_unit_id = grouped_ingredients.first.material.default_unit_id
    # 取得した食材の単位が全て合算用の単位と同じならsame_unitに代入
    same_unit = grouped_ingredients.all? { |ingredient| ingredient.unit_id == default_unit_id }

    # 取得した食材の単位が全て合算用の単位と同じ場合の処理
    total_quantity = if same_unit
      grouped_ingredients.sum(&:quantity)
    else
      # 取得した食材の単位がバラバラの場合、合算されたデータがsumに蓄積され戻り値としてtotal_quantityに格納
      grouped_ingredients.reduce(0) do |sum, ingredient|
        # MaterialUnitから変換率（conversion_factor）を取得
        material_unit = MaterialUnit.find_by(material_id: ingredient.material_id, unit_id: ingredient.unit_id)
        # 登録された数値と変換率（conversion_factor）を掛け、sumに蓄積する
        sum + ingredient.quantity * material_unit.conversion_factor
      end
    end

    total_quantity
  end
end