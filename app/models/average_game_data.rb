class AverageGameData

  def initialize(games, member)
    @games = games
    @member = member
  end

  def wins
    @games.where(winner_id: @member.id).size
  end

  def losses
    @games.where(loser_id: @member.id).size
  end

  def win_loss
    ((wins.to_f / (wins.to_f + losses.to_f)) * 100).round(2)
  end

  def avg_score
    total_score = []
    @games.each do |game|
      total_score << game.my_score(@member)
    end
    (total_score.sum / total_score.size).to_f.round(2) unless total_score.size.zero?
  end

  def avg_opponent_score
    total_score = []
    @games.each do |game|
      total_score << game.opponent_score(@member)
    end
    (total_score.sum / total_score.size).to_f.round(2) unless total_score.size.zero?
  end
end
