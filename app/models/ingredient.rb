class Ingredient < ApplicationRecord
  has_many :menus, through: :menu_ingredients
  belongs_to :material
  belongs_to :unit

  validates :material_id, presence: true, length: { maximum: 15 }
  validates :quantity, presence: true, length: { maximum: 4 }
  validates :unit_id, presence: true

  def validate_unique_name(ingredients)
    if ingredients.map(&:name).uniq.count != ingredients.count
      Rails.logger.info '名前にかぶりがあったよ'
      return false
    end

    Rails.logger.info '名前にかぶりなかったよ'
    return true
  end

end
