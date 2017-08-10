class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user  #ketika bikin account baru, bisa langsung login dengan call log_in @user (method di sessions_helper), jadi langsung bikin cookie untuk session
      flash[:success] = "Welcome to the Hadits Open. Tools for administering your hadist collection"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private 
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
