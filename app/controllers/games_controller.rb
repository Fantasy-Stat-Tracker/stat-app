class GamesController < ApplicationController
  before_action :require_user
  before_action :set_current_league

  def index
    @member = current_member
    games_constant = Game.where(home_id: @member.id)
                         .or(Game.where(away_id: @member.id))
                         .custom_filter(params.slice(:year), @member)
    @games = Game.where(home_id: @member.id)
                 .or(Game.where(away_id: @member.id))
                 .custom_filter(params.slice(:year, :week_number, :opposing_player, :game_type), @member)
                 .order(year: :desc)
                 .order(:week_number)
    win_loss_filter if params[:win_loss]
    @available_weeks = games_constant.distinct.pluck(:week_number)
    @game_opponents = opponent_builder(games_constant)
    @avg_data = AverageGameData.new(@games, @member)
    @form_path = league_games_path(@league_id)
    if turbo_frame_request?
      render partial: "shared/games_table"
    end
  end

  private

  def win_loss_filter
    if params[:win_loss] == "Win"
      @games = @games.where(winner_id: params[:viewed_member])
    elsif params[:win_loss] == "Loss"
      @games = @games.where(loser_id: params[:viewed_member])
    else
      @games
    end
  end

  def opponent_builder(games)
    opponents = []
    games.each do |game|
      opponents << game.opponent_member_object(@member)
    end
    opponents.uniq
  end

  def filtering_params(params)
    params.slice(:year, :week_number, :opposing_player, :game_type)
  end
end
