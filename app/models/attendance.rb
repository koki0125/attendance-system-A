class Attendance < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  attr_accessor :modified # modelにないけど、form_withでフラグとして使いたかったため
  
  scope :where_status, ->(status) { where(status: status) }
  scope :where_superior_id, ->(superior_id) { where(superior_id: superior_id) }
  
  # 'self.'はクラスメソッドにつける
  # overtime_params[:expected_finish_time] をDateTime型に整形して@overtime_params全体を返す
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
  
  # 上長承認のため、modelにない :modifiedフラグで、チェック済みのものだけをハッシュとして抽出
  def self.approval_overtime(attendances_params,appli_params)
    @appli_params = appli_params.to_unsafe_h #.permit!もある each or map
    @checked_overtimes = {};
    
    @appli_params.each do |op|
      if op[1]["modified"] == "1"
        @checked_overtimes.merge!( op[0] => {:status => op[1]["status"].to_i} )
      end
    end
    return @checked_overtimes
  end
  
  
end
