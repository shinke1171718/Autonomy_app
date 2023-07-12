class Menu < ApplicationRecord
  has_many :menu_users, dependent: :destroy
  has_many :users, through: :menu_users
end
