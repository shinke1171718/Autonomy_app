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
          total_quantity, unit_id_to_use = aggregate_quantities(ingredients_group)

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
      def aggregate_quantities(grouped_ingredients)

        # 複数の食材の合算数値
        total_quantity = 0
        exception_unit_id = @settings.dig('ingredient', 'no_quantity_unit_id').to_i
        exception_ingredient_quantity = @settings.dig('ingredient', 'exception_ingredient_quantity')

        # グループ内で使用されている全てのunit_idを取得
        filtered_unit_ids = grouped_ingredients.reject { |ingredient| ingredient.unit_id == exception_unit_id }.map(&:unit_id).uniq
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

  end