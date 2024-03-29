class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_one :shopping_list, dependent: :destroy
  has_one :cooking_flow, dependent: :destroy
end
