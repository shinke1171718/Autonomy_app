class CompletedMenu < ApplicationRecord
  belongs_to :user
  has_many :completed_menu_items, dependent: :destroy
  has_many :menus, through: :completed_menu_items
end
