class Game < ApplicationRecord
  belongs_to :week
  has_many :members
  scope :wins, -> (member) { where(winner_id: member) }
  scope :losses, -> (member) { where(loser_id: member) }
  scope :year, -> (year) { where year: year }
  scope :week_number, -> (week_number) { where week_number: week_number }
  scope :home_opposing_player, -> (member) { where home_id: member }
  scope :away_opposing_player, -> (member) { where away_id: member }
  scope :opposing_player, -> (member) { home_opposing_player(member).or(away_opposing_player(member)) }
  scope :game_type, -> (game) { where game_type: game }
  scope :pre_merger, -> (game) { where era: "old" }
  scope :post_merger, -> (game) {where era: "new" }

  before_create :set_winner, :set_loser, :set_year, :set_week
  before_save :create_total_score, :close?

  include Filterable

  def win_or_loss(member)
    if member.id == winner_id
      "Win"
    else
      "Loss"
    end
  end

  def home_or_away(member)
    if member.id == home_id
      "Home"
    else
      "Away"
    end
  end

  def my_score(member)
    if member.id == home_id
      home_score
    else
      away_score
    end
  end

  def opponent_score(member)
    if member.id == home_id
      away_score
    else
      home_score
    end
  end

  def opponent(member)
    if member.id == home_id
      Member.find(away_id).short_name
    else
      Member.find(home_id).short_name
    end
  end

  def opponent_member_object(member)
    if member.id == home_id
      Member.find(away_id)
    else
      Member.find(home_id)
    end
  end

  def year
    week.season.year
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

  def create_total_score
    home = self.home_score
    away = self.away_score
    self.total_score = home + away
  end

  def close?
    home = self.home_score
    away = self.away_score
    if (home - away).abs <= 3
      self.close = true
    else
      self.close = false
    end
  end
end
