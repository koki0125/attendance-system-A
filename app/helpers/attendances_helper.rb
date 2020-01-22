module AttendancesHelper
  
  def modified_working_hours(a,b)
    startedtime = Time.mktime(a.year, a.month, a.day, a.hour, a.min, 0, 0)
    finishedtime = Time.mktime(b.year, b.month, b.day, b.hour, b.min, 0, 0)
    return ( ( (finishedtime - startedtime) / 60) / 60).truncate(2)
  end

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
