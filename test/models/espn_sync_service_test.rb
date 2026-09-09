require 'test_helper'

class EspnSyncServiceTest < ActiveSupport::TestCase
  class FakeHttpClient
    attr_reader :requests

    def initialize(responses)
      @responses = responses
      @requests = []
    end

    def get(url, headers:)
      @requests << { url: url, headers: headers }
      @responses.shift
    end
  end

  test 'records ESPN final standings champion for playoff cleanup' do
    league = League.create!(
      name: 'League', start_year: 2024, source: 'espn', espn_league_id: '12345',
      espn_s2: 'session-token', swid: '{member-id}'
    )
    champion = league.members.create!(first_name: 'Champion', last_name: 'Member', email: 'champion@example.com', espn_id: '{champion}')
    runner_up = league.members.create!(first_name: 'Runner', last_name: 'Up', email: 'runner-up@example.com', espn_id: '{runner-up}')
    http_client = FakeHttpClient.new([
      {
        'teams' => [
          { 'id' => 1, 'primaryOwner' => '{champion}', 'rankCalculatedFinal' => 1 },
          { 'id' => 2, 'primaryOwner' => '{runner-up}', 'rankCalculatedFinal' => 2 }
        ]
      },
      { 'schedule' => [] }
    ])

    EspnSyncService.new(league: league, season_year: 2024, http_client: http_client).call

    season = league.seasons.find_by!(year: 2024)
    assert_equal champion, season.winning_member
    assert_equal true, season.member_seasons.find_by!(member: champion).is_winner
    assert_equal false, season.member_seasons.find_by!(member: runner_up).is_winner
    assert_equal(
      'https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/2024/segments/0/leagues/12345?view=mTeam',
      http_client.requests.first[:url]
    )
  end

  test 'uses the historical mTeam endpoint and unwraps its response' do
    league = League.create!(name: 'League', start_year: 2017, source: 'espn', espn_league_id: '12345')
    champion = league.members.create!(first_name: 'Champion', last_name: 'Member', email: 'champion@example.com', espn_id: '{champion}')
    http_client = FakeHttpClient.new([
      [{ 'teams' => [{ 'id' => 1, 'primaryOwner' => '{champion}', 'rankCalculatedFinal' => 1 }] }],
      [{ 'schedule' => [] }]
    ])

    EspnSyncService.new(league: league, season_year: 2017, http_client: http_client).call

    assert_equal champion, league.seasons.find_by!(year: 2017).winning_member
    assert_equal(
      'https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/leagueHistory/12345?seasonId=2017&view=mTeam',
      http_client.requests.first[:url]
    )
  end
end
