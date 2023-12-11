class ShoppingListItem < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :material
  belongs_to :unit
  belongs_to :category
end
