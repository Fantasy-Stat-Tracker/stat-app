namespace :league_creator do
  task :add_first_league => :environment do
    espn_s2 = '{AEAdshCPPuFg03laTsaAlLPVnApaS1f%2FhNxDyMEPKSrW81Ph%2FsQUcw97WrA%2B29jgcWZ5Gb5pIOf0EdzeVXCxxtFxF1eyEQ0H4IuU%2BspewlDjgYpwzfNqUsu1kk%2BNGt2Vqv%2FY56NCe2UbPEs6qbujIDkNpT%2BX0Kl6%2FrdK%2BQp5e7mYU9toEbFTsf0F7NZ1lSSc7zrEZMzifynrh2NPfbf%2BPccci6hxC9p2aOkWHug42%2FKb2eoRjbc3tiKm20QevlTQycg%3D}'
    swid = '{314F28D9-D972-4977-93BB-0C73C3879EB8}'
    name = "The Locker Room"

    league = League.find_or_create_by(name: name, start_year: 2009, source: "espn", espn_s2: espn_s2, swid: swid)

    Member.all.each do |m|
      m.league_id = league.id
      m.save
    end

    Season.all.each do |s|
      s.league_id = league.id
      s.save
    end
  end
end