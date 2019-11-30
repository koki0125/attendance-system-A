class Attendance < ApplicationRecord
  # userに紐づく、その逆も
  belongs_to :user
  validates :user_id, presence: true
end
