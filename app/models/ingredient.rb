class Ingredient < ApplicationRecord
  has_many :menu_ingredients, dependent: :destroy
  has_many :menus, through: :menu_ingredients
  belongs_to :material
  belongs_to :unit

  common_error_message = '登録中に予期せぬエラーが発生しました。'

  validates :material_name, presence: { message: common_error_message }
  validates :material_id, presence: { message: common_error_message }
  # 'quantity'は10桁まで許容。小数点含むためと、合算時の桁数考慮のため
  validates :quantity, presence: { message: common_error_message }, length: { maximum: 10, too_long: common_error_message }, unless: :skip_quantity_validation?
  validates :unit_id, presence: { message: common_error_message }

  validate :custom_quantity_validation, unless: :skip_quantity_validation?

  private
  # 特定の条件下で'quantity'バリデーションをスキップ
  def skip_quantity_validation?
    settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
    unit_id == settings.dig('ingredient', 'no_quantity_unit_id')
  end

  def custom_quantity_validation
    settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))

    # 設定ファイルから値をロード
    max_quantity_value = settings.dig('limits', 'max_quantity_value')
    max_integer_digits = settings.dig('limits', 'max_integer_digits')
    max_decimal_places = settings.dig('limits', 'max_decimal_places')

    # 初期状態ではエラーはないと仮定
    has_error = false

    # 数値が設定値以下であるかどうかをチェック
    if quantity.present? && quantity > max_quantity_value
      has_error = true
    end

    # 整数部が設定値の桁数以下であるかどうかをチェック
    if quantity.present? && quantity.to_i.to_s.length > max_integer_digits
      has_error = true
    end

    # 小数点がある場合、小数点以下の桁数が設定値以下であるかをチェック
    if quantity.present? && quantity.to_s.include?('.') && quantity.to_s.split('.').last.length > max_decimal_places
      has_error = true
    end

    # has_errorがtrueの場合、共通エラーメッセージを追加
    if has_error
      errors.add(:quantity, '登録中に予期せぬエラーが発生しました。')
    end
  end

end
