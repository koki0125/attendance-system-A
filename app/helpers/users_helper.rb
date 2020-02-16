module UsersHelper

  # 在社時間計上用
  def working_hours(a,b)
    startedtime = Time.mktime(a.year, a.month, a.day, a.hour, a.min, 0, 0)
    finishedtime = Time.mktime(b.year, b.month, b.day, b.hour, b.min, 0, 0)
    (((finishedtime - startedtime) / 60) / 60).truncate(2)
  end
  
  # 引数の時刻データの秒を０にして差を求める
  def times(x,y)
    c = Time.mktime(x.year, x.month, x.day, x.hour, x.min, 0, 0)
    d = Time.mktime(y.year, y.month, y.day, y.hour, y.min, 0, 0)
    (d - c).to_i
  end
  
  # 基本時間などの時刻データを指定の１０段階表示にする
  def basic_info_time(t)
    format("%.2f", ((t.hour * 60.0) + t.min)/60) if !t.blank?
  end
  
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  # 時間外時間計上用
  def overtime_hours(a,b)
    expected_finish_time = Time.mktime(a.year, a.month, a.day, a.hour, a.min, 0, 0)
    designated_finish_time = Time.mktime(b.year, b.month, b.day, b.hour, b.min, 0, 0)
    return ( ( (expected_finish_time - designated_finish_time) / 60) / 60).truncate(2)
  end
  
  # 上長ステータスの表示用（残業申請>勤怠編集申請）残業申請の方が優先
  def superior_response(d)
    return d[:status_overtime] != 0 ? (superior_response_o( d[:superior_id_overtime], d[:status_overtime] )) : ( d[:status_modified] != 0 ? (superior_response_m(d[:superior_id_modified], d[:status_modified])) : nil )
  end
    
  
  # 残業申請時の上長レスポンス欄に表示する文言
  def superior_response_o(d_superior_id, d_status)
    # "なし"   => 0,
    # "申請中" => 1,
    # "承認"   => 2,
    # "否認"   => 3 
    if d_superior_id.present?
      case d_status
        when 1
          User.find(d_superior_id).name+" に残業申請中"
        when 2
          "残業承認済 勤怠編集否認" #これ以降、勤怠編集禁止の意味
        when 3
          "残業否認 勤怠編集承認済" #
      end
    end
  end
  
  # 勤怠編集申請時の上長レスポンス欄に表示する文言
  def superior_response_m(d_superior_id, d_status)
    # "なし"   => 0,
    # "申請中" => 1,
    # "承認"   => 2,
    # "否認"   => 3 
    if d_superior_id.present?
      case d_status
        when 1
          User.find(d_superior_id).name+" に勤怠編集申請中"
        when 2
          "勤怠編集承認済" # 承認
        when 3
          "勤怠編集否認" # 否認
      end
    end
  end

  # 
  def superior_response_month(day)
    d = Attendance.find(day[:id])
    case d.status_month
      when 1
        "所属長承認　"+ User.find(d.superior_id_month).name+" に申請中"
      when 2
        "所属長承認　"+ User.find(d.superior_id_month).name+" から承認済み"
      when 3
        "所属長承認　"+ User.find(d.superior_id_month).name+" から否認されました"
      else
        "所属長承認　未"
    end
  end
  
# users/show
  # 表示できる時間 出社
  def show_started_time_h(d)
    if d.status_modified == 2
      hour = d.modified_started_time&.to_s(:hour) 
    else
      hour = d.started_time&.to_s(:hour) 
    end
    return hour
  end
  
  def show_started_time_m(d)
    if d.status_modified == 2
      minute = d.modified_started_time&.to_s(:minute) 
    else
      minute = d.started_time&.to_s(:minute) 
    end
    return minute
  end
  
  # 表示できる時間 退社
  def show_finished_time_h(d)
    if d.status_modified == 2
      hour = d.modified_finished_time&.to_s(:hour) 
    else
      hour = d.finished_time&.to_s(:hour)
    end 
    return hour
  end
  
  def show_finished_time_m(d)
    if d.status_modified == 2
      minute = d.modified_finished_time&.to_s(:minute) 
    else
      minute = d.finished_time&.to_s(:minute)
    end
    return minute
  end

  # @total_time計算用にfixした出社時間をわたす
  def started_time_for_total(d)
    if d.status_modified == 2
      started_time = d.modified_started_time
    else
      started_time = d.started_time
    end
    return started_time
  end
  
  # @total_time計算用にfixした退社時間をわたす
  def finished_time_for_total(d)
    if d.status_overtime == 2
      finished_time = d.expected_finish_time
    elsif d.status_modified == 2
      finished_time = d.modified_finished_time
    else
      finished_time = d.finished_time
    end
    return finished_time
  end
  
  
end