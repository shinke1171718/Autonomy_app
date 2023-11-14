class Ingredient < ApplicationRecord
  has_many :menus, through: :menu_ingredients
  belongs_to :material
  belongs_to :unit

  validates :material_id, presence: true, length: { maximum: 15 }
  validates :quantity, presence: true, length: { maximum: 4 }, unless: :skip_quantity_validation?
  validates :unit_id, presence: true

  private

  def skip_quantity_validation?
    unit_id == 17
  end

end
