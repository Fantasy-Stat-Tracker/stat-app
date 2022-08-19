class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
  helper_method :current_member

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_member
    #this will need to be updated when users have multiple teams / members
    current_user ? @current_user.members.first : nil
  end

  def set_current_league
    @league_id = current_member.league.id
  end

  def require_user
    unless current_user
      redirect_to :root
    end
  end
end
