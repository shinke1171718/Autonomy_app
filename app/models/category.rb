class Category < ApplicationRecord
  has_many :materials
  has_many :shopping_list_items
end
