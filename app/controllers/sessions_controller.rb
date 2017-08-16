class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        # Log the user in and redirect to the user's show page
        log_in user #calling method on session_helper
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # remember user
        redirect_back_or user #redirect_to user #calling redirect_back_or function on sessions_helper.rb
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning]=message
        redirect_to root_url
      end
    else
      # create an error message
      flash.now[:danger] = 'Invalid email/password combination' #not quite right!
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
