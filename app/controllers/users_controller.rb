class UsersController < ApplicationController
  before_action :logged_in_user, only:[:index, :edit, :update, :destroy] #perintah untuk allow edit and update for logged user only.
  before_action :correct_user, only:[:edit, :update] #perintah untuk allow edit datanya sendiri saja. data orang lain tidak bisa di edit
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #log_in @user  #ketika bikin account baru, bisa langsung login dengan call log_in @user (method di sessions_helper), jadi langsung bikin cookie untuk session
      #UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      #flash[:success] = "Welcome to the Hadits Open. Tools for administering your hadist collection"
      flash[:info] = "Please check your email to activate your account."
      #redirect_to @user
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #handle success update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private 
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # before filters
    
    #confirm a logged in user
    def logged_in_user
      unless logged_in? # if not logged (goes below condition)
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end
    
    #confirm the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) #@user == current_user
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
