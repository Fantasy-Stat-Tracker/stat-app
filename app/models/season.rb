class Season < ApplicationRecord
  has_many :weeks
  has_many :games, through: :weeks
  has_many :member_seasons
  has_many :members, through: :member_seasons
  belongs_to :league

  def find_winner(season)
    member = season.member_seasons.find_by(is_winner:true)&.member_id
    Member.find(member).full_name if member
  end

  def winning_member
    self.member_seasons.find_by(is_winner:true).member
  end

  def clean_playoffs
    all_playoff_games = self.games.where(game_type: "Playoffs")
    playoff_games_that_matter = traverse_playoff_tree(championship_game)
    games_to_delete = all_playoff_games - playoff_games_that_matter
    games_to_delete.each(&:destroy)
  end

  private

  def last_week_of_playoffs
    self.weeks.maximum(:number)
  end

  def championship_game
    championship_week = self.last_week_of_playoffs
    return nil unless championship_week # Handle case where there is no playoff week

    championship_games = self.games.where(week_id: self.weeks.find_by(number: championship_week)&.id)
    winner = self.winning_member
    return nil unless winner # Handle case where there is no winning member

    championship_games.find_by(winner_id: winner.id)
  end

  def previous_round_games(game)
    winner_game = self.games.find_by(winner_id: game.winner_id, week_id: game.week_id - 1)
    loser_game = self.games.find_by(winner_id: game.loser_id, week_id: game.week_id - 1)

    [winner_game, loser_game].compact
  end

  def traverse_playoff_tree(game, games_collected = [])
    # Add the current game to the collected games
    games_collected << game

    # Get previous round games
    previous_games = previous_round_games(game)

    # Recursively traverse each previous game
    previous_games.each do |prev_game|
      next unless prev_game.game_type == "Playoffs"
      traverse_playoff_tree(prev_game, games_collected)
    end

    games_collected
  end
end
