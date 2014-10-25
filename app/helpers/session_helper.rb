module SessionHelper

  attr_accessor :user
  def isLoggedIn?
    session[:timestamp] = 15.minutes.from_now and return true if session[:user_id] and
                          session[:timestamp] and session[:timestamp].to_datetime > Time.now
    logOut and return false
  end

  def logIn(user)
    session[:user_id] = user.id
    session[:timestamp] = 15.minutes.from_now
  end

  def logOut
    reset_session
  end

  def showUser
    user = User.find(session[:user_id])
    return user
  end

  def invalidAttempt
    flash.now[:error] = "Your login/password is incorrect."
  end
end
