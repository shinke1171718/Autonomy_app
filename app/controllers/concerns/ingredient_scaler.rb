module IngredientScaler

  private

  def scale_ingredients(ingredients, menu_count)
    menu_count = menu_count.to_i
    ingredients.map do |ingredient|
      new_ingredient = ingredient.dup
      new_ingredient.quantity *= menu_count
      new_ingredient
    end
  end
end
