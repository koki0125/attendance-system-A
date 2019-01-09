require "date"
require "csv"
class UsersController < ApplicationController
  include UsersHelper
  before_action :logged_in_user, only: %i[index edit update destroy]
  # before_action :correct_user,   only: %i[edit update]
  before_action :admin_user,     only: %i[index basic_info destroy]
  before_action :admin_user__current_user,  only: %i[edit update]
  #before_action :superior_user,     only: %i[index basic_info destroy]
  
  
  def index
    @users = User.all.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def show
    # .find = id のみで探す場合
    @user = User.find(params[:id])
    if current_user.admin? || current_user.id == @user.id
      
      
      # 曜日表示用に使用する %w = 配列を作る
      @week = %w{日 月 火 水 木 金 土}
     
      # 既に表示月があれば、表示月を取得する
      # first_dayがnilでないなら
      if not params[:first_day].nil?
        # Date.parse() 日時を表す文字列を解釈し、数値を返します
        @first_day = Date.parse(params[:first_day])
      else
        # 表示月が無ければ、今月分を表示
        # .beginning_of_month = 今月の初めの日付を取得
        @first_day = Date.current.beginning_of_month
      end
      #最終日を取得する
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
    
    
      # 当月を昇順で取得し@daysへ代入　= @first_day =< >= @last_day
      @days = @user.attendances.where('attendance_day >= ? and attendance_day <= ?', \
      @first_day, @last_day).order('attendance_day')
      # 在社時間の集計、ついでに出勤日数も
      i = 0
      @days.each do |d|
        if d.started_time.present? && d.finished_time.present?
          second = 0
          second = times(d.started_time,d.finished_time)  #times = users_helperで定義している
          @total_time = @total_time.to_i + second.to_i
          i = i + 1
        end
      end
     
      # 出勤日数、どっち使ってもOK
      @attendances_count = i
      @attendances_sum = @days.where.not(started_time: nil, finished_time: nil).count
    else
      flash[:warning] = "他のユーザーの勤��情報は閲覧できません。"
      redirect_to current_user 
      return
    end
  end
  
  # 出勤ボタン
  def started_time
    @user = User.find(params[:id])
    @started_time = @user.attendances.find_by(attendance_day: Date.current)
    @started_time.update_attributes(started_time: DateTime.new(DateTime.now.year,\
    DateTime.now.month, DateTime.now.day,DateTime.now.hour,DateTime.now.min,0))
    flash[:info] = "今日も１日元気に頑張りましょう！"
    redirect_to @user 
  end
  
  # 退勤ボタン
  def finished_time
    @user = User.find(params[:id])
    @finished_time = @user.attendances.find_by(attendance_day: Date.current)
    finishedtime = DateTime.new(DateTime.now.year,DateTime.now.month,\
    DateTime.now.day,DateTime.now.hour,DateTime.now.min,0)
    @finished_time.update_attributes(finished_time: finishedtime)
    flash[:info] = "今日も一日お疲れ様でした！"
    redirect_to @user 
  end

  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "登録が完了しました"
      redirect_back_or @user 
    else
      render 'new'
    end
  end
   
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました"
    redirect_to users_url
  end
  
  def basic_info
    if params[:id].nil?
       @user  = User.find(current_user.id)
    else
       @user  = User.find(params[:id])
    end
  end
  
  def basic_info_edit
    @user  = User.find(params[:id])
  
    if @user.update_attributes!(user_params)

      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      flash[:danger] = "基本情報の更新に失敗しました。"
      redirect_to @user
    end
  end
  
  #出勤中社員一覧
  def working_employees_index
    @users = User.all.paginate(page: params[:page])
    # @user = User.find(params[:id])
    @we = {}
      @users.each do |user|
      if user.attendances.any?{ |a|
          (a.attendance_day == Date.today &&
          !a.started_time.blank? && a.finished_time.blank? 
          )
        }
          ##空の@weハッシュに追加する、下記両方とも同じ意味
          # @we[user.name] = user.employee_number
          @we.store(user.name, user.employee_number)
      end
    end
  end
  
  # CSV入力
  def csv_import
    # @user = User.find(params[:id])
    # User.read(params[:file])
    User.import(params[:csv_file])
    redirect_to @user
  end


  private

  # ストロングパラメーター
    def user_params
      params.require(:user).permit(:name, :email, :department, :password,
                                   :basic_time, :specified_working_time,
                                   :password_confirmation)
    end
    
    def search_params
      params.require(:q).permit(:name_cont)
    end

    # beforeフィルター

    # 正しいユーザーかどうかを確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    # 上長かどうかを確認
    def superior_user
      redirect_to(root_url) unless current_user.superior?
    end
    
    def admin_user__current_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin?||current_user?(@user)
    end
end