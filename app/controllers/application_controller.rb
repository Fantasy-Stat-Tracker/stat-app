class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      redirect_to login_path
    end
  end
end
