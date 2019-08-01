class GamesController < ApplicationController
  before_action :require_user

  def user_games
    @games_constant = Game.where(home_id: current_user.id).or(Game.where(away_id: current_user.id)).filter(params.slice(:year))
    @games = Game.where(home_id: current_user.id).or(Game.where(away_id: current_user.id)).filter(params.slice(:year, :week_number, :opposing_player, :game_type)).order(:year, :week_number)
    @available_weeks = weeks_builder(@games_constant)
    @game_opponents = opponent_builder(@games_constant)
    @wins = @games.where(winner_id: current_user.id).size
    @losses = @games.where(loser_id: current_user.id).size
    @win_loss = (@wins.to_f / (@wins.to_f + @losses.to_f)).round(4)
    @avg_score = avg_score(@games, current_user).to_f.round(2)
    @avg_opponent_score = opponent_avg_score(@games, current_user).to_f.round(2)
  end

  private

  def weeks_builder(games)
    weeks = []
    games.each { |game| weeks << game.week_number }
    weeks.uniq
  end

  def avg_score(games, user)
    total_score = []
    games.each do |game|
      total_score << game.my_score(user)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_avg_score(games, user)
    total_score = []
    games.each do |game|
      total_score << game.opponent_score(user)
    end
    total_score.sum / total_score.size unless total_score.size.zero?
  end

  def opponent_builder(games)
    opponents = []
    games.each do |game|
      opponents << game.opponent_user_object(current_user)
    end
    opponents.uniq
  end

  def filtering_params(params)
    params.slice(:year, :week_number, :opposing_player, :game_type)
  end
end