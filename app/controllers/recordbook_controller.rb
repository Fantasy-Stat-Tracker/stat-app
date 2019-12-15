class RecordbookController < ApplicationController
  before_action :require_user

  def game_index
    @games = Game.all
    @game_highscore = @games.order(:total_score).last(5).reverse
    @game_lowscore = @games.order(:total_score).first(5)
    @single_game_high = order_highscores(@games).last(5).reverse
    @single_game_low = order_highscores(@games).first(5)
  end

  def game_espn
    @games = Game.where(era: "espn")
    @game_highscore = @games.order(:total_score).last(5).reverse
    @game_lowscore = @games.order(:total_score).first(5)
    @single_game_high = order_highscores(@games).last(5).reverse
    @single_game_low = order_highscores(@games).first(5)
  end

  def game_fleaflicker
    @games = Game.where(era: "fleaflicker")
    @game_highscore = @games.order(:total_score).last(5).reverse
    @game_lowscore = @games.order(:total_score).first(5)
    @single_game_high = order_highscores(@games).last(5).reverse
    @single_game_low = order_highscores(@games).first(5)
  end

  def season_index
  end

  def season_espn
  end

  def season_fleaflicker
  end

  def all_time_index
  end

  def all_time_espn
  end

  def all_time_fleaflicker
  end

  private

  def order_highscores(games)
    scores_arr = []
    games.each do |game|
      scores_arr << [game.home_score, game.home_id, game.year, game.week.number]
      scores_arr << [game.away_score, game.away_id, game.year, game.week.number]
    end
    scores_arr.sort_by!{|game_arr| game_arr[0]}
  end
end
