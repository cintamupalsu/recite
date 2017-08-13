module SessionsHelper
  #helper is used to implement these module on all controller
  
  #login in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #remember a user in a persistent session
  def remember(user)
    user.remember #calling method in user.rb (models) to generate remember_token attribute
    cookies.permanent.signed[:user_id] = user.id #To store the user's ID in the cookies.
    cookies.permanent[:remember_token] = user.remember_token #to store the token of user in the cookies
  end
  
  #return true if the given user is the current user
  def current_user?(user)
    user == current_user
  end
  #return the current logged-in user (if any) and
  #return the user corresponding to the remember token cookie
  def current_user
    #@current_user ||= User.find_by(id: session[:user_id])
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end  
    end
  end
  
  #return true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end
  
  #Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  #logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #redirects to stored location (or to default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
end
