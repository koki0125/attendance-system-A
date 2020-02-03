class BasesController < ApplicationController
  before_action :admin_user
  
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def delete
  end
  
  
  private
        # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
