class UserSeason < ApplicationRecord
  belongs_to :user
  belongs_to :season

  before_save :update_stats

  def update_stats
    update_points
    calculate_wins
    calculate_close_games
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

  def calculate_wins
    user = self.user
    season = self.season
    user_games = season.games.where("home_id = ? or away_id = ?", user.id, user.id)
    total_games(user, user_games)
    regular_season_games(user, user_games)
    playoff_games(user, user_games)
  end

  def total_games(user, user_games)
    games = []
    user_games.each do |game|
      games << game.win_or_loss(user)
    end
    self.wins = games.count("Win")
    self.losses = games.count("Loss")
    self.win_percentage = wins.to_f / (wins.to_f + losses.to_f)
  end

  def regular_season_games(user, user_games)
    updated_games = user_games.where(game_type: "Regular")
    games = []
    updated_games.each do |game|
      games << game.win_or_loss(user)
    end
    self.regular_season_wins = games.count("Win")
    self.regular_season_losses = games.count("Loss")
  end

  def playoff_games(user, user_games)
    updated_games = user_games.where(game_type: "Playoffs")
    games = []
    updated_games.each do |game|
      games << game.win_or_loss(user)
    end
    self.playoff_wins = games.count("Win")
    self.playoff_losses = games.count("Loss")
  end

  def calculate_close_games
    user = self.user
    season = self.season
    close_games_arr = season.games.where("home_id = ? or away_id = ?", user.id, user.id).where(close: true)
    self.close_games = close_games_arr.count
    self.close_wins = close_games_arr.where(winner_id: user.id).count
    self.close_losses = close_games_arr.where(loser_id: user.id).count
  end
end