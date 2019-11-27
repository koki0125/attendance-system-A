class Attendance < ApplicationRecord
  # userに紐づく、その逆も
  belongs_to :user
end
