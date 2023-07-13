class Menu < ApplicationRecord
  has_many :menu_users, dependent: :destroy
  has_many :users, through: :menu_users
  has_one_attached :image
  has_many :ingredients, dependent: :destroy
end
