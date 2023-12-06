class Ingredient < ApplicationRecord
  has_many :menu_ingredients
  has_many :menus, through: :menu_ingredients
  belongs_to :material
  belongs_to :unit

  validates :material_name, presence: true
  validates :material_id, presence: true, length: { maximum: 15 }
  validates :quantity, presence: true, length: { maximum: 4 }, unless: :skip_quantity_validation?
  validates :unit_id, presence: true

  private

  def skip_quantity_validation?
    settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
    unit_id == settings.dig('ingredient', 'no_quantity_unit_id')
  end

end
