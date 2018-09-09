class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    #@users = User.all
    # @users = User.paginate(page: params[:page])
    
    # @words = Word.page(params[:page]).per(PER)   参考にkaminari paginateの
    @users = User.all.paginate(page: params[:page])
  end
  
  def show
    
    if logged_in?
      @user = current_user
    end
    
    @user = User.find(params[:id])
    
    @date = DateTime.now
    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    # 今月
    @yearmonth = @date.strftime("%Y年%m月")
    # 先月と来月
    @perv_month = @date.prev_month.strftime("%Y年%m月")
    @next_month = @date.next_month.strftime("%Y年%m月")
    
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
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "登録が完了しました"
      redirect_back_or user
    else
      render 'new'
    end
  end
   
  def edit
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password,
                                   :password_confirmation)
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
end