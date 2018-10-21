class HomeController < ApplicationController
  def top
  end
  

  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :activated,
    :affiliation, :basic_time, :specified_working_time, :password_confirmation)
  end
  
  def search_params
    params.require(:q).permit(:name_cont)
  end
  
  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
