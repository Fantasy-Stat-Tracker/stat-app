namespace :era do
  task :add_era => :environment do
    Game.all.each do |game|
      if game.year < 2016
        game.era = "fleaflicker"
        game.save!
      else
        game.era = "espn"
        game.save!
      end
    end
  end
end