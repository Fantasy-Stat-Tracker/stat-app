class UserSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season

  before_save :update_stats

  def update_stats
    update_points
  end

  def update_points
    user = self.user
    season = self.season
    user_games = season.games.where("home_id = ? or away_id = ?", user.id, user.id)
    calculate_total_points(user_games, user)
    calculate_regular_season_points(user_games, user)
    calculate_playoff_points(user_games, user)
  end

  def calculate_total_points(games, user)
    total_scores_arr = []
    games.each do |game|
      if game.home_id == user.id
        total_scores_arr << game.home_score
      else
        total_scores_arr << game.away_score
      end
    end
    self.points = total_scores_arr.sum
  end

  def calculate_regular_season_points(games, user)
    updated_games = games.where(game_type: "Regular")
    total_scores_arr = []
    updated_games.each do |game|
      if game.home_id == user.id
        total_scores_arr << game.home_score
      else
        total_scores_arr << game.away_score
      end
    end
    self.regular_season_points = total_scores_arr.sum
  end

  def calculate_playoff_points(games, user)
    updated_games = games.where(game_type: "Playoffs")
    total_scores_arr = []
    updated_games.each do |game|
      if game.home_id == user.id
        total_scores_arr << game.home_score
      else
        total_scores_arr << game.away_score
      end
    end
    self.playoff_points = total_scores_arr.sum
  end

  def update_wins
    user = self.user
    season = self.season
    user_games = season.games.where("home_id = ? or away_id = ?", user.id, user.id)
  end
end