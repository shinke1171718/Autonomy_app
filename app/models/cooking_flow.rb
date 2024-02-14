class CookingFlow < ApplicationRecord
  belongs_to :cart
  has_many :cooking_steps, dependent: :destroy
end
