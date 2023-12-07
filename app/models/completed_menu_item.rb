class CompletedMenuItem < ApplicationRecord
  belongs_to :completed_menu
  belongs_to :menu
end
