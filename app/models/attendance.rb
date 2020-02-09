class Attendance < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  attr_accessor :modified  # modelにないけど、form_withでフラグとして使いたかったため
  
  scope :where_users_firstday,  ->(attendance_day)  { where(attendance_day:  attendance_day::text ) }
  scope :where_status_month,    ->(status_month)    { where(status_month:    status_month   ) }
  scope :where_status_modified, ->(status_modified) { where(status_modified: status_modified) }
  scope :where_status_overtime, ->(status_overtime) { where(status_overtime: status_overtime) }
  
  scope :where_superior_id_month,    ->(superior_id_month)    { where(superior_id_month:    superior_id_month) }
  scope :where_superior_id_modified, ->(superior_id_modified) { where(superior_id_modified: superior_id_modified) }
  scope :where_superior_id_overtime, ->(superior_id_overtime) { where(superior_id_overtime: superior_id_overtime) }
  
  # 'self.'はクラスメソッドにつける
  # overtime_params[:expected_finish_time] をDateTime型に整形して@overtime_params全体を返す :tomorrow処理
  def self.fmt_overtime_params(overtime_params,params)
    @overtime_params = overtime_params
    if overtime_params[:tomorrow] == "1"
      @overtime_params[:expected_finish_time] = 
      Time.zone.parse( "#{Date.parse(params[:date])+1} #{overtime_params[:expected_finish_time]}")
    else
      @overtime_params[:expected_finish_time] = 
      Time.zone.parse( "#{params[:date]} #{overtime_params[:expected_finish_time]}")
    end
    return @overtime_params
  end
  
  # 本当は上記とまとめた方が良い。。。リファクタリングの余地あり
  # 勤怠編集用の日時フォーマット(:tomorrow処理も)
  def self.fmt_modified_params(params)
    @params = params[:attendances]
    @params.each do |id, item|
      if item[:tomorrow] == "1"
        item[:modified_finished_time] = 
        Time.zone.parse( "#{Date.parse(item[:attendance_day])+1} #{item[:modified_finished_time]}")
      else
        item[:modified_finished_time] = 
        Time.zone.parse( "#{item[:attendance_day]} #{item[:modified_finished_time]}")
      end
      item[:modified_started_time] = 
        Time.zone.parse( "#{item[:attendance_day]} #{item[:modified_started_time]}")
    end
    return @params
  end
  
  # 上長承認のため、modelにない :modifiedフラグで、チェック済みのものだけをハッシュとして抽出
  def self.approval_modified(attendances_params,appli_params)
    @appli_params = appli_params.to_unsafe_h #.permit!もある each or map
    @checked_modifieds = {};
    
    @appli_params.each do |mp|
      if mp[1]["modified"] == "1"
        @checked_modifieds.merge!( mp[0] => {:status_modified => mp[1]["status_modified"].to_i} )
      end
    end
    return @checked_modifieds
  end
    
  # 上長承認のため、modelにない :modifiedフラグで、チェック済みのものだけをハッシュとして抽出
  def self.approval_overtime(attendances_params,appli_params)
    @appli_params = appli_params.to_unsafe_h #.permit!もある each or map
    @checked_overtimes = {};
    
    @appli_params.each do |op|
      if op[1]["modified"] == "1"
        @checked_overtimes.merge!( op[0] => {:status_overtime => op[1]["status_overtime"].to_i} )
      end
    end
    return @checked_overtimes
  end
  
  # 上長の名前
  def self.superior_name(id)
    @superior = User.find(id)
    return @superior.name
  end
  
  
end
