class BasesController < ApplicationController
  before_action :admin_user
  
  def index
  end
  
  def edit
  end
  
  private
        # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
