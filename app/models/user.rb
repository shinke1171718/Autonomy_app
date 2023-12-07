class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attr_accessor :current_password

  has_many :menu_users, dependent: :destroy
  has_many :menus, through: :menu_users
  has_one :cart, dependent: :destroy
  has_many :completed_menus, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
end
