class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  helper_method :current_member

  private

  def current_member
    @current_member ||= Member.find(session[:user_id]) if session[:user_id]
  end

  def set_current_league
    @league_id = current_member.league.id
  end

  def require_member
    unless current_member
      redirect_to login_path
    end
  end
end
