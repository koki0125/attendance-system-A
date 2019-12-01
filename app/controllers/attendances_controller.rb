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
  def update_all
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
  
# 残業申請モーダル
  def form_overtime
    # 表示用
    @user = User.find(params[:id])
    # 特定の日付のID
    @day = @user.attendances.where(id: params[:a_id])
    @week = %w{日 月 火 水 木 金 土}
    # 自分以外の上長達
    @superiors = User.where(superior: true).where.not(id: @user.id)
  end

#個別残業申請
  def submit_overtime
    @user = User.find(params[:user][:user_id])
    # userに紐づく残業申請日
    @attendance = Attendance.where(id: params[:user][:attendances][:id])
    # フォーマットされたovertime_paramsを更新
    if @attendance.update(Attendance.fmt_overtime_params(overtime_params,params))
      flash[:success] = '残業申請をしました。'
      redirect_to user_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
    else
      flash[:danger] = "残業申請に失敗しました。"
      # redirect_to user_url(@user, params:{ id: @user.id, first_day: params[:first_day]})
      render :form_overtime
    end
  end
  
# 残業申請確認（上長ユーザー）
  def check_overtime
    
  end

# 残業申請回答（上長ユーザー）
  def res_overtime
    
  end
  
  
  # プライベート
  private
  
    def attendances_params
      params.permit(attendances: [ :id, :started_time, :finished_time, :expected_finish_time,
                                  :detail, :reason, :tomorrow, :superior_id, :status])[:attendances]
    end
    
    # def user_params
    #   params.require(:user).permit(:name, :email, :department, :password,
    #                               :basic_time, :specified_working_time,
    #                               :password_confirmation, 
    #                               attendances_attributes: [:id, :attendances, :started_time,
    #                               :started_time, :finished_time,
    #                               :expected_finish_time, :detail, :reason,
    #                               :tomorrow, :superior_id, :status])
    # end
    
    # 残業申請用
    def overtime_params
      params.require(:user).permit( attendances: [:id,
                                   :expected_finish_time, :reason,
                                   :tomorrow, :superior_id, :status])[:attendances]
    end
end