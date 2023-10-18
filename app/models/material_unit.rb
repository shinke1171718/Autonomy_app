class MaterialUnit < ApplicationRecord
  belongs_to :ingredient
  belongs_to :material
  belongs_to :unit
end
