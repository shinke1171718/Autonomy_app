class ShoppingListMenu < ApplicationRecord
  belongs_to :shopping_list
  belongs_to :menu
end
