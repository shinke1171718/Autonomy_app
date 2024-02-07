class Menu < ApplicationRecord
  has_many :user_menu, dependent: :destroy
  has_many :users, through: :menu_users
  has_one_attached :image
  has_many :menu_ingredients, dependent: :destroy
  has_many :ingredients, through: :menu_ingredients, autosave: false
  has_many :cart_items, dependent: :destroy
  has_many :shopping_list_menus, dependent: :restrict_with_exception
  has_many :shopping_lists, through: :shopping_list_menus
  has_many :completed_menus, dependent: :destroy

  validates :menu_name, presence: { message: '登録中に予期せぬエラーが発生しました。' }, length: { maximum: 15, message: '登録中に予期せぬエラーが発生しました。' }
  validates :menu_contents, presence: { message: '登録中に予期せぬエラーが発生しました。' }, length: { maximum: 60, message: '登録中に予期せぬエラーが発生しました。' }
  validates :contents, presence: { message: '登録中に予期せぬエラーが発生しました。' }, length: { maximum: 1500, message: '登録中に予期せぬエラーが発生しました。' }
  before_validation :set_default_image

  # モデルのingredientモデルのバリデーション設定
  validate :validate_ingredients

  # 複数のingredientデータを格納するために設定しています。
  attr_accessor :ingredients, :encoded_image, :image_content_type, :image_data_url

  private

  def set_default_image
    if image.blank?
      default_image = Rails.root.join("app/assets/images/default-menu-icon.png")
      self.image.attach(io: File.open(default_image), filename: "default-menu-icon.png")
    end
  end

  def validate_ingredients
    ingredients.each do |ingredient|
      if !ingredient.valid?
        ingredient.errors.full_messages.each do |message|
          errors.add(:base, message)
        end
      end
    end
  end

end
