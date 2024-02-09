class RecipeStep < ApplicationRecord
  belongs_to :menu
  belongs_to :recipe_step_category
end
