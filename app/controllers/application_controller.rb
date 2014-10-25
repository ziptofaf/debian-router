class ApplicationController < ActionController::Base
  include SessionHelper
  attr_accessor :user
  before_action :authorize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authorize
    if !isLoggedIn?
      redirect_to session_login_panel_path and @loggedUser = nil and return
    else
      @loggedUser ||= showUser
    end
  end

  def adminAuthorize
    flash[:error] = "You don't have necessary privileges to access this feature" and redirect_to root_path unless @loggedUser.level>=1
  end
end
