class MemberSeason < ApplicationRecord
  belongs_to :member
  belongs_to :season
  has_many :games, through: :season

  before_save :update_stats

  def update_stats
    return if games.size.zero?

    update_points
    calculate_wins
    calculate_close_games
    calculate_year
  end

  def update_points
    member = self.member
    season = self.season
    member_games = season.games.where("home_id = ? or away_id = ?", member.id, member.id)
    calculate_total_points(member_games, member)
    calculate_regular_season_points(member_games, member)
    calculate_playoff_points(member_games, member)
  end

  def calculate_total_points(games, member)
    total_scores_arr = []
    games.each do |game|
      if game.home_id == member.id
        total_scores_arr << game.home_score
      else
        total_scores_arr << game.away_score
      end
    end
    self.points = total_scores_arr.sum
    self.points_per_game = total_scores_arr.sum / total_scores_arr.size
  end

  def calculate_regular_season_points(games, member)
    updated_games = games.where(game_type: "Regular")
    total_scores_arr = []
    updated_games.each do |game|
      if game.home_id == member.id
        total_scores_arr << game.home_score
      else
        total_scores_arr << game.away_score
      end
    end
    self.regular_season_points = total_scores_arr.sum
  end

  def calculate_playoff_points(games, member)
    updated_games = games.where(game_type: "Playoffs")
    total_scores_arr = []
    updated_games.each do |game|
      if game.home_id == member.id
        total_scores_arr << game.home_score
      else
        total_scores_arr << game.away_score
      end
    end
    self.playoff_points = total_scores_arr.sum
  end

  def calculate_wins
    member = self.member
    season = self.season
    member_games = season.games.where("home_id = ? or away_id = ?", member.id, member.id)
    total_games(member, member_games)
    regular_season_games(member, member_games)
    playoff_games(member, member_games)
  end

  def total_games(member, member_games)
    games = []
    member_games.each do |game|
      games << game.win_or_loss(member)
    end
    self.wins = games.count("Win")
    self.losses = games.count("Loss")
    self.win_percentage = wins.to_f / (wins.to_f + losses.to_f)
  end

  def regular_season_games(member, member_games)
    updated_games = member_games.where(game_type: "Regular")
    games = []
    updated_games.each do |game|
      games << game.win_or_loss(member)
    end
    self.regular_season_wins = games.count("Win")
    self.regular_season_losses = games.count("Loss")
  end

  def playoff_games(member, member_games)
    updated_games = member_games.where(game_type: "Playoffs")
    games = []
    updated_games.each do |game|
      games << game.win_or_loss(member)
    end
    self.playoff_wins = games.count("Win")
    self.playoff_losses = games.count("Loss")
  end

  def calculate_close_games
    member = self.member
    season = self.season
    close_games_arr = season.games.where("home_id = ? or away_id = ?", member.id, member.id).where(close: true)
    self.close_games = close_games_arr.count
    self.close_wins = close_games_arr.where(winner_id: member.id).count
    self.close_losses = close_games_arr.where(loser_id: member.id).count
  end

  def calculate_year
    self.year = self.season.year
  end
end