class Unit < ApplicationRecord
  has_many :material_units
  has_many :materials, through: :material_units
  has_many :shopping_list_items
end
