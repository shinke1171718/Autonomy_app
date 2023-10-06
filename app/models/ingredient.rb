class Ingredient < ApplicationRecord
  has_many :menus, through: :menu_ingredients

  validates :name, presence: true, length: { maximum: 15 }
  validates :quantity, presence: true, length: { maximum: 4 }
  validates :unit, inclusion: { in: ['g', 'kg', 'ml', 'L', '個', '枚', '匹', '切れ', '丁', '杯', '缶', '本', '袋', '束', '合', '大さじ', '小さじ'] }

  def validate_unique_name(ingredients)
    if ingredients.map(&:name).uniq.count != ingredients.count
      Rails.logger.info '名前にかぶりがあったよ'
      return false
    end

    Rails.logger.info '名前にかぶりなかったよ'
    return true
  end

end
