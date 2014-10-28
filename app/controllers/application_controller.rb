class ApplicationController < ActionController::Base
  include SessionHelper
  attr_accessor :user
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorize
    if !isLoggedIn?
      redirect_to login_path and @loggedUser = nil and return
    else
      @loggedUser ||= showUser #this is pretty much a User.find using session[:user_id]
    end
  end

  def adminAuthorize
    flash[:error] = "You don't have necessary privileges to access this feature" and redirect_to root_path unless @loggedUser.level>=1 #admins have privileges level of 2
  end
end
