class AttendancesController < ApplicationController
  
  def edit
    
    if logged_in?
      @user = current_user
    end
    
    @user = User.find(params[:id])
    
    @date = Date.today
    
    # 曜日表示用に使用する
    @week = %w[日 月 火 水 木 金 土]
    
    # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月が無ければ、今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    #最終日を取得する
    @last_day = @first_day.end_of_month
    

    
  end
  
  def index
  end
  
end