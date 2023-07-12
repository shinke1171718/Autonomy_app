class UserMenu < ApplicationRecord
  belongs_to :menu, dependent: :destroy
  belongs_to :user, dependent: :destroy
end
