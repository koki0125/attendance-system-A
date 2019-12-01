class Attendance < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  
  # overtime_params[:expected_finish_time] をTateTime型に整形して@overtime_params全体を返す
  def self.fmt_overtime_params(overtime_params,params)
    @overtime_params = overtime_params
    if overtime_params[:tomorrow] == "1"
      @overtime_params[:expected_finish_time] = 
      DateTime.parse( "#{params[:date]} #{overtime_params[:expected_finish_time]}")+1
    else
      @overtime_params[:expected_finish_time] = 
      DateTime.parse( "#{params[:date]} #{overtime_params[:expected_finish_time]}")
    end
    return @overtime_params
  end
  
end
