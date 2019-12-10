class RecordbookController < ApplicationController
  before_action :require_user

  def index
    @old_game_highscore = Game.order
  end
end
