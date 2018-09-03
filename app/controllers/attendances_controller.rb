class AttendancesController < ApplicationController
  
  def edit
    
    if logged_in?
      @user = current_user
    end
    
    @user = User.find(params[:id])
    
    @date = Date.today
    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    
    # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月が無ければ、今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    #最終日を取得する
    @last_day = @first_day.end_of_month
    
     # 今月の初日から最終日の期間分を取得
      @days_of_month = (@first_day..@last_day).each do |date|
      # # 該当日付のデータがないなら作成する
      # #(例)user1に対して、今月の初日から最終日の値を取得する
      #   if !@user.attendances.any? {|attendance| attendance.day == date }
      #   linked_attendance = Attendance.create(user_id: @user.id, day: date)
      #   linked_attendance.save
      #   end
      end
  
    # # 表示期間の勤怠データを日付順にソートして取得 show.html.erb、 <% @attendances.each do |attendance| %>からの情報
    # @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
    
  end
  
  def index
  end
  
end