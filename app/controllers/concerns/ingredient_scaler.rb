module IngredientScaler

  private

  def scale_ingredients(ingredients, menu_count)
    menu_count = menu_count.to_i
    ingredient_settings = @settings['ingredient']
    exception_ingredient_quantity = ingredient_settings['exception_ingredient_quantity']
    no_quantity_unit_id = ingredient_settings['no_quantity_unit_id']
    default_unit_id = ingredient_settings['default_unit_id']
    min_items_to_scale = @settings.dig('limits', 'min_items_to_scale')

    ingredients.map do |ingredient|
      new_ingredient = ingredient.dup

      if menu_count == min_items_to_scale
        new_ingredient_quantity = new_ingredient.quantity
      end

      if menu_count > min_items_to_scale
        new_ingredient_quantity = new_ingredient.quantity || exception_ingredient_quantity
        new_ingredient.quantity = new_ingredient_quantity *= menu_count
      end

      if new_ingredient.unit_id == no_quantity_unit_id && menu_count > min_items_to_scale
        new_ingredient.unit_id = default_unit_id
      end

      new_ingredient
    end
  end
end
