require 'test_helper'

class SeasonTest < ActiveSupport::TestCase
  test 'clean_playoffs keeps the champion bracket based on the recorded winner' do
    league = League.create!(name: 'League', start_year: 2024)
    season = league.seasons.create!(year: 2024)
    champion, runner_up, semifinalist_one, semifinalist_two = [
      ['Champion', 'champion@example.com'],
      ['Runner Up', 'runner-up@example.com'],
      ['Semifinalist One', 'semifinalist-one@example.com'],
      ['Semifinalist Two', 'semifinalist-two@example.com']
    ].map do |name, email|
      first_name, last_name = name.split(' ', 2)
      league.members.create!(first_name: first_name, last_name: last_name, email: email)
    end
    season.member_seasons.create!(member: champion, is_winner: true)
    season.member_seasons.create!(member: runner_up, is_winner: false)
    season.member_seasons.create!(member: semifinalist_one, is_winner: false)
    season.member_seasons.create!(member: semifinalist_two, is_winner: false)
    semifinal_week = season.weeks.create!(number: 15)
    championship_week = season.weeks.create!(number: 16)

    first_semifinal = create_playoff_game(semifinal_week, champion, semifinalist_one, 100, 90)
    second_semifinal = create_playoff_game(semifinal_week, runner_up, semifinalist_two, 100, 90)
    championship = create_playoff_game(championship_week, champion, runner_up, 100, 90)
    consolation = create_playoff_game(championship_week, semifinalist_one, semifinalist_two, 100, 90)

    season.clean_playoffs

    assert_equal [championship.id, first_semifinal.id, second_semifinal.id].sort, season.games.pluck(:id).sort
    assert_not Game.exists?(consolation.id)
  end

  private

  def create_playoff_game(week, home, away, home_score, away_score)
    Game.create!(
      week: week,
      game_type: 'Playoffs',
      home_id: home.id,
      away_id: away.id,
      home_score: home_score,
      away_score: away_score
    )
  end
end
