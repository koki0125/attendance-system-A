class AttendancesController < ApplicationController
  def show
    @user = User.find(params[:id])
    
  end
  
  def index
  end

  def edit
  end
  
  
end