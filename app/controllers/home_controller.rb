class HomeController < ApplicationController
  layout "home"

  def index
    redirect_to league_games_path(current_member.league) if current_member
  end
end
