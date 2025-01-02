class EspnSyncService
  attr_reader :espn_s2, :swid, :league_id, :season_year

  def initialize(league:, season_year:)
    @league = league
    @season_year = season_year
  end

  def call
    players_response = fetch_players_response
    games_response = fetch_games_response

    return if games_response.values.empty?

    year_season = create_or_find_season
    process_players(players_response, year_season)
    process_games(games_response, year_season)
  end

  private

  def fetch_players_response
    cookie = "espnAuth={\"swid\":\"#{@league.swid}\"}; espn_s2=#{@league.espn_s2};"

    HTTParty.get(
      "https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/#{@season_year}/segments/0/leagues/#{@league.espn_league_id}?view=mTeam",
      headers: {
        "Cookie": cookie,
      }
    )
  end

  def fetch_games_response
    cookie = "espnAuth={\"swid\":\"#{@league.swid}\"}; espn_s2=#{@league.espn_s2};"

    HTTParty.get(
      "https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/#{@season_year}/segments/0/leagues/#{@league.espn_league_id}?view=mMatchup",
      headers: {
        "Cookie": cookie,
      },
    )
  end

  def create_or_find_season
    Season.find_or_create_by!(year: @season_year, league_id: @league.id)
  end

  def process_players(players_response, year_season)
    players_response['teams'].each do |player|
      member = find_or_map_member(player['primaryOwner'])
      next unless member

      MemberSeason.find_or_create_by(
        season_id: year_season.id,
        member_id: member.id,
        espn_team_id: player['id']
      )
    end
  end

  def find_or_map_member(primary_owner)
    if primary_owner == '{36344C0F-14C1-4EB8-B569-EFC4DDD513A8}'
      Member.find_by(espn_id: '{672670FB-77F1-4338-8186-1E308855B6BE}')
    else
      Member.find_by(espn_id: primary_owner)
    end
  end

  def process_games(games_response, year_season)
    games_response['schedule'].each do |game|
      week = Week.find_or_create_by(
        number: game['matchupPeriodId'],
        season_id: year_season.id
      )

      home_user_season = MemberSeason.find_by(espn_team_id: game['home']['teamId'])
      away_user_season = MemberSeason.find_by(espn_team_id: game['away']['teamId'])

      Game.find_or_create_by(
        game_type: game['matchupPeriodId'] > 14 ? 'Playoffs' : 'Regular',
        week_id: week.id,
        home_score: game['home']['totalPoints'],
        away_score: game['away']['totalPoints'],
        home_id: home_user_season&.member_id,
        away_id: away_user_season&.member_id
      )
    end
  end
end
