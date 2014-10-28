class SessionController < ApplicationController
  include SessionHelper
  skip_before_action :authorize
  def login
    invalidAttempt and render 'login_panel' and return unless session_params[:username] and
                session_params[:password] and User.exists?(:username => session_params[:username].to_s)
    user = User.find_by username: session_params[:username].to_s
    invalidAttempt and render 'login_panel' and return unless user.authenticate(session_params[:password])
    logIn(user)
    redirect_to root_path
  end

  def logout
    logOut
    flash.now[:info] = "You have succesfully logged out"
    render 'login_panel'
  end

  def login_panel
    redirect_to root_path and flash[:info] = "You are already logged in" and return if isLoggedIn?
  end

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
