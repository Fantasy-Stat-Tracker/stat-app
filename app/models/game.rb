class Game < ApplicationRecord
  belongs_to :week
  has_many :users

  before_save :set_winner, :set_loser

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
end
