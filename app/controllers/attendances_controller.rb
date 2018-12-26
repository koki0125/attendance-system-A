require "time"

class AttendancesController < ApplicationController

  # 勤怠編集画面 
  def edit
    @user = User.find(params[:id])
    if current_user.admin? || current_user.id == @user.id

      @week = %w{日 月 火 水 木 金 土}
      
      if not params[:first_day].nil?
        @first_day = Date.parse(params[:first_day])
      else
        @first_day = Date.current.beginning_of_month
      end
      
      @last_day = @first_day.end_of_month
      
      # 取得月の初日から終日まで繰り返し処理
      (@first_day..@last_day).each do |day|
        # attendancesテーブルに各日付のデータがあるか
        if not @user.attendances.any? { |obj| obj.attendance_day == day }
          # ない日付はインスタンスを生成して保存する
          date = Attendance.new(user_id: @user.id, attendance_day: day)
          date.save
        end
      end
      
      # 当月を昇順で取得し@daysへ代入
      @days = @user.attendances.where('attendance_day >= ? and attendance_day <= ?', \
      @first_day, @last_day).order('attendance_day')
    else
      flash[:warning] = "他のユーザーの勤怠情報は閲覧できません。"
      redirect_to current_user
    end
  end

  # 勤怠編集画面ー更新ボタン
  def update_bunch
    @user = User.find(params[:id])
    
    attendances_params.each do |id, time|
      attendance = Attendance.find(id)
      
      #当日以降の編集はadminユーザのみ
      if attendance.attendance_day > Date.current && !current_user.admin?
    
      elsif time["started_time"].blank? && time["finished_time"].blank?

      #出社時間と退社時間の両方の存在を確認
      elsif time["started_time"].blank? || time["finished_time"].blank?
        flash[:warning] = '一部編集が無効となった項目があります。'
      
      #出社時間 > 退社時間ではないか
      elsif time["started_time"].to_s > time["finished_time"].to_s
        flash[:warning] = '出社時間より退社時間が早い項目がありました'
      
      else
        attendance.update_attributes(time)
        flash[:success] = '勤怠時間を更新しました。なお本日以降の更新はできません。'
      end
    end #eachの締め
    redirect_to user_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
  end
  
      # def update_bunch
        
      #   @user = User.find(params[:id])
      #   attendances_params.each do |id, item|
      #   attendance = Attendance.find(id)
      #     #未来の情報は一般ユーザーは更新できないように設定（管理者のみ編集可能）
      #     if attendance.attendance_day > Date.today && !current_user.admin?
      #       raise
              
      #     #出社時間と退社時間の両方の存在を検証
      #     elsif attendance.attendance_day!=Date.today && item["started_time"].blank? ^ item["finished_time"].blank?
      #       flash[:warning] = '出社時間と退社時間は両方入力してください。'
      #     #出社時間より退社時間が遅いことを検証
      #     elsif item["started_time"].to_s > item["finished_time"].to_s
      #       flash[:warning] = '出社時間＜退社時間となるように入力してください。'
      #     else
      #       attendance.update_attributes(item)
      #       flash[:success] = "更新しました！なお本日以降の更新はできません。"
      #     end
      #   end
      # #セレクトユーザーの編集した月ページへ
      # redirect_to  user_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
      # end


  # プライベート
  private
  
    def attendances_params
      params.permit(attendances: [:started_time, :finished_time])[:attendances]
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :department, :password,
                                   :basic_time, :specified_working_time,
                                   :password_confirmation)
    end

end