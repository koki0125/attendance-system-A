module AttendancesHelper

  def calculate_overtime(over, basic)
    sec = Time.parse(over) - Time.parse(basic)
    p sec
    if sec < 0
      sec = sec * -1
      return "-"+Time.at(sec).utc.strftime("%R")
    end
    return Time.at(sec).utc.strftime("%R")
  end
  
end
