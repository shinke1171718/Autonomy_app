class Material < ApplicationRecord
  belongs_to :category
  has_one :ingredient
  has_many :material_units
  has_many :units, through: :material_units
  has_many :shopping_list_items
end
