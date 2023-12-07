class Menu < ApplicationRecord
  has_many :menu_users, dependent: :destroy
  has_many :users, through: :menu_users
  has_one_attached :image
  has_many :menu_ingredients, dependent: :destroy
  has_many :ingredients, through: :menu_ingredients, autosave: false
  has_many :cart_items, dependent: :destroy

  validates :menu_name, presence: true, length: { maximum: 15 }
  validates :menu_contents, presence: true, length: { maximum: 20 }
  validates :contents, presence: true, length: { maximum: 1500 }
  before_validation :set_default_image

  # 複数のingredientデータを格納するために設定しています。
  attr_accessor :ingredients, :encoded_image, :image_content_type, :image_data_url

  private

  def set_default_image
    if image.blank?
      default_image = Rails.root.join("app/assets/images/default-menu-icon.png")
      self.image.attach(io: File.open(default_image), filename: "default-menu-icon.png")
    end
  end

end
