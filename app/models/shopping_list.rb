class ShoppingList < ApplicationRecord
  belongs_to :cart
  has_many :shopping_list_items, dependent: :destroy
  has_many :shopping_list_menus, dependent: :destroy
  has_many :menus, through: :shopping_list_menus
end
