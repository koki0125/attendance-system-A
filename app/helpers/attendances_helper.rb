module AttendancesHelper

# 残業時間の計算（残業時間 - 定時）
# @param  str Time
# @return str Time
  def calculate_overtime(over, basic)
    sec = Time.parse(over) - Time.parse(basic)
    p sec
    if sec < 0
      sec = sec * -1
      return "-"+Time.at(sec).utc.strftime("%R")
    end
    return Time.at(sec).utc.strftime("%R")
  end
  
# 残業ステータスの表示分け
# @param  int 0 ~ 3
# @return str
  def overtime_status(num)
    case num
      when 0 then return "なし"
      when 1 then return "申請中"
      when 2 then return "受理"
      when 3 then return "却下"
    end
  end
end
