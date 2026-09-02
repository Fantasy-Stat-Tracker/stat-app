require 'test_helper'

class EspnSeasonLeagueMetadataSyncServiceTest < ActiveSupport::TestCase
  class FakeHttpClient
    attr_reader :request

    def initialize(response)
      @response = response
    end

    def get(url, headers:)
      @request = { url: url, headers: headers }
      @response
    end
  end

  test 'persists ESPN league metadata for a season' do
    league = League.create!(
      name: 'Local name',
      start_year: 2024,
      source: 'espn',
      espn_league_id: '12345',
      espn_s2: 'session-token',
      swid: '{member-id}'
    )
    response = {
      'settings' => {
        'name' => 'ESPN League Name',
        'size' => 12,
        'scheduleSettings' => {
          'matchupPeriodCount' => 14,
          'playoffTeamCount' => 6,
          'playoffMatchupPeriodLength' => 2,
          'playoffSeedingRule' => 'TOTAL_POINTS',
          'matchupPeriods' => { '1' => [1], '15' => [15, 16] }
        },
        'scoringSettings' => {
          'scoringType' => 'H2H_POINTS',
          'playoffMatchupTieRule' => 'MOST_POINTS',
          'scoringItems' => [{ 'statId' => 53, 'points' => 4 }]
        }
      }
    }

    http_client = FakeHttpClient.new(response)
    season = EspnSeasonLeagueMetadataSyncService.new(
      league: league,
      season_year: 2024,
      http_client: http_client
    ).call

    assert_equal 'ESPN League Name', season.league_name
    assert_equal 12, season.team_count
    assert_equal 'H2H_POINTS', season.scoring_type
    assert_equal 14, season.regular_season_matchup_count
    assert_equal 6, season.playoff_team_count
    assert_equal 2, season.playoff_matchup_period_length
    assert_equal 'TOTAL_POINTS', season.playoff_seeding_rule
    assert_equal 'MOST_POINTS', season.playoff_matchup_tie_rule
    assert_equal({ '1' => [1], '15' => [15, 16] }, season.matchup_periods)
    assert_equal response['settings']['scoringSettings'], season.scoring_settings
    assert_equal(
      'https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/2024/segments/0/leagues/12345?view=mSettings',
      http_client.request[:url]
    )
    assert_equal 'espnAuth={"swid":"{member-id}"}; espn_s2=session-token;', http_client.request[:headers]['Cookie']
  end

  test 'updates the existing season instead of creating another' do
    league = League.create!(name: 'League', start_year: 2024, source: 'espn', espn_league_id: '12345')
    season = league.seasons.create!(year: 2024, team_count: 10)
    response = { 'settings' => { 'name' => 'League', 'size' => 12 } }

    synced_season = EspnSeasonLeagueMetadataSyncService.new(
      league: league,
      season_year: 2024,
      http_client: FakeHttpClient.new(response)
    ).call

    assert_equal season.id, synced_season.id
    assert_equal 12, synced_season.team_count
    assert_equal 1, league.seasons.where(year: 2024).count
  end

  test 'uses ESPN historical endpoint for seasons before 2018' do
    league = League.create!(name: 'League', start_year: 2009, source: 'espn', espn_league_id: '12345')
    http_client = FakeHttpClient.new({ 'settings' => { 'name' => 'League', 'size' => 10 } })

    EspnSeasonLeagueMetadataSyncService.new(
      league: league,
      season_year: 2009,
      http_client: http_client
    ).call

    assert_equal(
      'https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/leagueHistory/12345?seasonId=2009&view=mSettings',
      http_client.request[:url]
    )
  end
end
