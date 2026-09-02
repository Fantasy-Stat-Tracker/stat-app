class EspnSeasonLeagueMetadataSyncService
  def initialize(league:, season_year:, http_client: HTTParty)
    @league = league
    @season_year = season_year
    @http_client = http_client
  end

  def call
    season = @league.seasons.find_or_create_by!(year: @season_year)
    season.update!(metadata_attributes(fetch_settings))
    season
  end

  private

  def fetch_settings
    response = @http_client.get(
      endpoint,
      headers: { "Cookie" => cookie }
    )

    response.fetch('settings')
  end

  def endpoint
    if @season_year < 2018
      "https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/leagueHistory/#{@league.espn_league_id}?seasonId=#{@season_year}&view=mSettings"
    else
      "https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/#{@season_year}/segments/0/leagues/#{@league.espn_league_id}?view=mSettings"
    end
  end

  def cookie
    "espnAuth={\"swid\":\"#{@league.swid}\"}; espn_s2=#{@league.espn_s2};"
  end

  def metadata_attributes(settings)
    schedule_settings = settings.fetch('scheduleSettings', {})
    scoring_settings = settings.fetch('scoringSettings', {})

    {
      league_name: settings['name'],
      team_count: settings['size'],
      scoring_type: scoring_settings['scoringType'],
      regular_season_matchup_count: schedule_settings['matchupPeriodCount'],
      playoff_team_count: schedule_settings['playoffTeamCount'],
      playoff_matchup_period_length: schedule_settings['playoffMatchupPeriodLength'],
      playoff_seeding_rule: schedule_settings['playoffSeedingRule'],
      playoff_matchup_tie_rule: scoring_settings['playoffMatchupTieRule'],
      scoring_settings: scoring_settings,
      matchup_periods: schedule_settings.fetch('matchupPeriods', {})
    }
  end
end
