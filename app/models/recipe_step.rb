class RecipeStep < ApplicationRecord
  belongs_to :menu, optional: true
  belongs_to :recipe_step_category
  has_many :cooking_steps

  # 全てのバリデーションエラーメッセージを統一
  common_error_message = '登録中に予期せぬエラーが発生しました。'

  validates :recipe_step_category_id, presence: { message: common_error_message }
  validates :description, presence: { message: common_error_message }, length: { maximum: 60, message: common_error_message }
  # コールバックを使用してstep_orderを自動設定
  before_validation :set_step_order, on: :create

  private

  def set_step_order
    settings = YAML.load_file(Rails.root.join('config', 'settings.yml'))
    initial_step_order = settings.dig('recipe_step', 'initial_step_order')
    step_order_increment = settings.dig('recipe_step', 'step_order_increment')

    # 現在のmenu_idに属する最後のstep_orderを取得し、1を加算する
    # 現在のメニューに属するレシピステップがない場合は1を設定
    self.step_order = (RecipeStep.where(menu_id: menu_id).maximum(:step_order) || initial_step_order) + step_order_increment
  end
end
