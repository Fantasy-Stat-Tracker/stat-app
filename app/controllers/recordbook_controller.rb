class RecordbookController < ApplicationController
  before_action :require_member

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
    @seasons = MemberSeason.all
    @most_points = @seasons.order(:points).last(5).reverse
    @least_points = @seasons.order(:points).first(5)
    @most_ppg = @seasons.order(:points_per_game).last(5).reverse
    @most_regular_season_points = @seasons.order(:regular_season_points).last(5).reverse
    @most_playoff_points = @seasons.order(:playoff_points).last(5).reverse
    @most_wins = @seasons.order(:wins).last(5).reverse
    @most_losses = @seasons.order(:losses).last(5).reverse
    @close_games = @seasons.order(:close_games).last(5).reverse
    @close_wins = @seasons.order(:close_wins).last(5).reverse
    @close_losses = @seasons.order(:close_losses).last(5).reverse
    @win_percentage = @seasons.order(:win_percentage).last(5).reverse
  end

  def season_espn
    @seasons = MemberSeason.where("year > ?", 2015)
    @most_points = @seasons.order(:points).last(5).reverse
    @least_points = @seasons.order(:points).first(5)
    @most_ppg = @seasons.order(:points_per_game).last(5).reverse
    @most_regular_season_points = @seasons.order(:regular_season_points).last(5).reverse
    @most_playoff_points = @seasons.order(:playoff_points).last(5).reverse
    @most_wins = @seasons.order(:wins).last(5).reverse
    @most_losses = @seasons.order(:losses).last(5).reverse
    @close_games = @seasons.order(:close_games).last(5).reverse
    @close_wins = @seasons.order(:close_wins).last(5).reverse
    @close_losses = @seasons.order(:close_losses).last(5).reverse
    @win_percentage = @seasons.order(:win_percentage).last(5).reverse
  end

  def season_fleaflicker
    @seasons = MemberSeason.where("year < ?", 2016)
    @most_points = @seasons.order(:points).last(5).reverse
    @least_points = @seasons.order(:points).first(5)
    @most_ppg = @seasons.order(:points_per_game).last(5).reverse
    @most_regular_season_points = @seasons.order(:regular_season_points).last(5).reverse
    @most_playoff_points = @seasons.order(:playoff_points).last(5).reverse
    @most_wins = @seasons.order(:wins).last(5).reverse
    @most_losses = @seasons.order(:losses).last(5).reverse
    @close_games = @seasons.order(:close_games).last(5).reverse
    @close_wins = @seasons.order(:close_wins).last(5).reverse
    @close_losses = @seasons.order(:close_losses).last(5).reverse
    @win_percentage = @seasons.order(:win_percentage).last(5).reverse
  end

  def all_time_index
    @wins = order_all_time(:wins).sort_by {|member, wins| wins}.last(5).reverse
    @losses = order_all_time(:losses).sort_by {|member, losses| losses}.last(5).reverse
    @playoff_wins = order_all_time(:playoff_wins).sort_by {|member, wins| wins}.last(5).reverse
    @playoff_losses = order_all_time(:playoff_losses).sort_by {|member, losses| losses}.last(5).reverse
    @points = order_all_time(:points).sort_by {|member, points| points}.last(5).reverse
  end

  def all_time_espn
    @wins = order_all_time(:wins, 2015, ">").sort_by {|member, wins| wins}.last(5).reverse
    @losses = order_all_time(:losses, 2015, ">").sort_by {|member, losses| losses}.last(5).reverse
    @playoff_wins = order_all_time(:playoff_wins, 2015, ">").sort_by {|member, wins| wins}.last(5).reverse
    @playoff_losses = order_all_time(:playoff_losses, 2015, ">").sort_by {|member, losses| losses}.last(5).reverse
    @points = order_all_time(:points, 2015, ">").sort_by {|member, points| points}.last(5).reverse
  end

  def all_time_fleaflicker
    @wins = order_all_time(:wins, 2016, "<").sort_by {|member, wins| wins}.last(5).reverse
    @losses = order_all_time(:losses, 2016, "<").sort_by {|member, losses| losses}.last(5).reverse
    @playoff_wins = order_all_time(:playoff_wins, 2016, "<").sort_by {|member, wins| wins}.last(5).reverse
    @playoff_losses = order_all_time(:playoff_losses, 2016, "<").sort_by {|member, losses| losses}.last(5).reverse
    @points = order_all_time(:points, 2016, "<").sort_by {|member, points| points}.last(5).reverse
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

  def order_all_time(value_string, where_param = nil, sign = nil)
    hash = {}
    Member.all.each do |member|
      if where_param
        seasons = MemberSeason.where(member_id: member.id).where("year #{sign} ?", where_param)
      else
        seasons = MemberSeason.where(member_id: member.id)
      end
      arr = []
      seasons.each do |season|
        arr << season.send(value_string)
      end
      hash[member.id] = arr.sum
    end
    hash
  end
end
