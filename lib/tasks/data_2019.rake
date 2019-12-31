namespace :data_2019 do
  task :add_games => :environment do
    players_response = HTTParty.get('http://fantasy.espn.com/apis/v3/games/ffl/seasons/2019/segments/0/leagues/91115?view=mTeam')
    games_response = HTTParty.get('https://fantasy.espn.com/apis/v3/games/ffl/seasons/2019/segments/0/leagues/91115?view=mMatchup
      ')
    year_season = Season.create(year: 2019) unless games_response.values.empty?

    binding.pry

  end
end