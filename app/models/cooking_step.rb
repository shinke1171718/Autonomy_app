class CookingStep < ApplicationRecord
  belongs_to :cooking_flow
  belongs_to :recipe_step
end
