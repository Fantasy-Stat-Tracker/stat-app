class GamesController < ApplicationController
  before_action :require_user
  before_action :set_current_league

  def member_games
    @games_constant = Game.where(home_id: current_member.id).or(Game.where(away_id: current_member.id)).custom_filter(params.slice(:year), current_member)
    @games = Game.where(home_id: current_member.id).or(Game.where(away_id: current_member.id)).custom_filter(params.slice(:year, :week_number, :opposing_player, :game_type), current_member).order(year: :desc).order(:week_number)
    win_loss_filter if params[:win_loss]
    @available_weeks = weeks_builder(@games_constant)
    @game_opponents = opponent_builder(@games_constant)
    @wins = @games.where(winner_id: current_member.id).size
    @losses = @games.where(loser_id: current_member.id).size
    @win_loss = ((@wins.to_f / (@wins.to_f + @losses.to_f)) * 100).round(2)
    @avg_score = avg_score(@games, current_member).to_f.round(2)
    @avg_opponent_score = opponent_avg_score(@games, current_member).to_f.round(2)
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

  def weeks_builder(games)
    weeks = []
    games.each { |game| weeks << game.week_number }
    weeks.uniq
  end

  def avg_score(games, member)
    total_score = []
    games.each do |game|
      total_score << game.my_score(member)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_avg_score(games, member)
    total_score = []
    games.each do |game|
      total_score << game.opponent_score(member)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_builder(games)
    opponents = []
    games.each do |game|
      opponents << game.opponent_member_object(current_member)
    end
    opponents.uniq
  end

  def filtering_params(params)
    params.slice(:year, :week_number, :opposing_player, :game_type)
  end
end