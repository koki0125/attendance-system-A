module AttendancesHelper

  # 残業時間の計算（残業時間 - 定時）
  # @param  str Time
  # @return str Time
  def calculate_overtime(over, basic)
    sec = Time.parse(over) - Time.parse(basic)
    if sec < 0
      sec = sec * -1
      return "-"+Time.at(sec).utc.strftime("%R")
    end
    return Time.at(sec).utc.strftime("%R")
  end
  
end
