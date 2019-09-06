class Attendance < ApplicationRecord
  # userに紐づく、その逆も
  belongs_to :user, inverse_of: :attendances
end
