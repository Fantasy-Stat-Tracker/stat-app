class Game < ApplicationRecord
  belongs_to :week
  has_many :users
  scope :wins, -> { where(winner_id: current_user.id) }
  scope :year, -> (year) { where year: year }
  scope :week_number, -> (week_number) { where week_number: week_number }
  scope :home_opposing_player, -> (user) { where home_id: user }
  scope :away_opposing_player, -> (user) { where away_id: user }
  scope :opposing_player, -> (user) { home_opposing_player(user).or(away_opposing_player(user)) }
  scope :game_type, -> (game) { where game_type: game }

  before_create :set_winner, :set_loser, :set_year, :set_week

  include Filterable

  def win_or_loss(user)
    if user.id == winner_id
      "Win"
    else
      "Loss"
    end
  end

  def home_or_away(user)
    if user.id == home_id
      "Home"
    else
      "Away"
    end
  end

  def my_score(user)
    if user.id == home_id
      home_score
    else
      away_score
    end
  end

  def opponent_score(user)
    if user.id == home_id
      away_score
    else
      home_score
    end
  end

  def opponent(user)
    if user.id == home_id
      User.find(away_id).full_name
    else
      User.find(home_id).full_name
    end
  end

  def opponent_user_object(user)
    if user.id == home_id
      User.find(away_id)
    else
      User.find(home_id)
    end
  end

  def year
    self.week.season.year
  end

  private

  def set_winner
    if home_score > away_score
      self.winner_id = home_id
    else
      self.winner_id = away_id
    end
  end

  def set_loser
    home_score < away_score ? self.loser_id = home_id : self.loser_id = away_id
  end

  def set_year
    self.year = self.week.season.year
  end

  def set_week
    self.week_number = self.week.number
  end
end
