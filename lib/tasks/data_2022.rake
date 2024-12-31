namespace :data_2022 do
  task add_games: :environment do
    espn_s2 = '{AEAdshCPPuFg03laTsaAlLPVnApaS1f%2FhNxDyMEPKSrW81Ph%2FsQUcw97WrA%2B29jgcWZ5Gb5pIOf0EdzeVXCxxtFxF1eyEQ0H4IuU%2BspewlDjgYpwzfNqUsu1kk%2BNGt2Vqv%2FY56NCe2UbPEs6qbujIDkNpT%2BX0Kl6%2FrdK%2BQp5e7mYU9toEbFTsf0F7NZ1lSSc7zrEZMzifynrh2NPfbf%2BPccci6hxC9p2aOkWHug42%2FKb2eoRjbc3tiKm20QevlTQycg%3D}'
    swid = '{314F28D9-D972-4977-93BB-0C73C3879EB8}'

    players_response = HTTParty.get(
      'http://fantasy.espn.com/apis/v3/games/ffl/seasons/2022/segments/0/leagues/91115?view=mTeam', { headers: { "Cookie": "espn_s2=#{espn_s2}; SWID=#{swid};" } }
    )
    games_response = HTTParty.get(
      'https://fantasy.espn.com/apis/v3/games/ffl/seasons/2022/segments/0/leagues/91115?view=mMatchup', { headers: { "Cookie": "espn_s2=#{espn_s2}; SWID=#{swid};" } }
    )
    year_season = Season.find_or_create_by!(year: 2022, league_id: 1) unless games_response.values.empty?

    # needed to add espn player id's for the season
    players_response['teams'].each do |player|
      p player, 'player'
      member = if player['primaryOwner'] == '{36344C0F-14C1-4EB8-B569-EFC4DDD513A8}'
                 Member.find_by(espn_id: '{672670FB-77F1-4338-8186-1E308855B6BE}')
               else
                 Member.find_by(espn_id: player['primaryOwner'])
               end
      p member, 'GOLDMEMBER'
      MemberSeason.find_or_create_by(season_id: year_season.id, member_id: member.id, espn_team_id: player['id'])
    end

    games_response['schedule'].each do |game|
      p game, 'HERE IS THE GAME'
      week = Week.find_or_create_by(number: game['matchupPeriodId'], season_id: year_season.id)
      home_user_season = MemberSeason.find_by(espn_team_id: game['home']['teamId'])
      home_user = home_user_season.member
      away_user_season = MemberSeason.find_by(espn_team_id: game['away']['teamId'])
      away_user = away_user_season.member
      Game.find_or_create_by(game_type: game['matchupPeriodId'] > 14 ? 'Playoffs' : 'Regular', week_id: week.id,
                             home_score: game['home']['totalPoints'], away_score: game['away']['totalPoints'], home_id: home_user.id, away_id: away_user.id)
    end
  end
end
