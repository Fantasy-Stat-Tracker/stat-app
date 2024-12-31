class GamesController < ApplicationController
  before_action :require_user
  before_action :set_current_league
  before_action :set_member

  def index
    @games = Game.where(home_id: @member.id)
                 .or(Game.where(away_id: @member.id))
                 .custom_filter(params.slice(:year, :week_number, :opposing_player, :game_type), @member)
                 .order(year: :desc)
                 .order(:week_number)
    win_loss_filter if params[:win_loss]
    build_form_helpers(params)
    @avg_data = AverageGameData.new(@games, @member)
    @form_path = league_games_path(@league_id)
    render partial: 'shared/games_table' if turbo_frame_request?
  end

  private

  def set_member
    @member = current_member
  end

  def win_loss_filter
    if params[:win_loss] == 'Win'
      @games = @games.where(winner_id: params[:viewed_member])
    elsif params[:win_loss] == 'Loss'
      @games = @games.where(loser_id: params[:viewed_member])
    else
      @games
    end
  end

  def build_form_helpers(params)
    available_games = Game.where(home_id: @member.id)
                          .or(Game.where(away_id: @member.id))
                          .custom_filter(params.slice(:year), @member)

    @available_weeks = available_weeks(available_games)
    @game_opponents = opponent_builder(available_games)
  end

  def available_weeks(games)
    games.distinct.pluck(:week_number)
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
