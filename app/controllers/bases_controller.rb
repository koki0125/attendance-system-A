class BasesController < ApplicationController
  before_action :admin_user
  
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end
  
  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点を追加しました"
      redirect_to bases_path and return
    else
      render 'new'
    end
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update(base_params)
      flash[:success] = "拠点情報を修正しました"
      redirect_to bases_path
    else
      render 'edit'
    end
  end
  
  def destroy
    Base.find(params[:id]).destroy
    flash[:success] = "拠点を削除しました"
    redirect_to bases_path
  end
  
  def basic_info
    if params[:id].nil?
       @user  = User.find(current_user.id)
    else
       @user  = User.find(params[:id])
    end
  end
  
  
  private
        # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_type)
    end
end
