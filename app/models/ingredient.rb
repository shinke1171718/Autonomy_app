class Ingredient < ApplicationRecord
  has_many :menu_ingredients, dependent: :destroy
  has_many :menus, through: :menu_ingredients
  belongs_to :material
  belongs_to :unit

  validates :material_name, presence: { message: '登録中に予期せぬエラーが発生しました。' }
  validates :material_id, presence: { message: '登録中に予期せぬエラーが発生しました。' }

  # 'quantity'は10桁まで許容。小数点含むためと、合算時の桁数考慮のため
  validates :quantity, presence: { message: '登録中に予期せぬエラーが発生しました。' }, length: { maximum: 10, too_long: '登録中に予期せぬエラーが発生しました。' }, unless: :skip_quantity_validation?

  validates :unit_id, presence: { message: '登録中に予期せぬエラーが発生しました。' }

  private

  # 特定の条件下で'quantity'バリデーションをスキップ
  def skip_quantity_validation?
    settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
    unit_id == settings.dig('ingredient', 'no_quantity_unit_id')
  end

end
