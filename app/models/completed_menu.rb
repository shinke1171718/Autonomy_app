class CompletedMenu < ApplicationRecord
  belongs_to :user
  belongs_to :menu
end
