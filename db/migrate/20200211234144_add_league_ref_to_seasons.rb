class AddLeagueRefToSeasons < ActiveRecord::Migration[5.2]
  def change
    add_reference :seasons, :league, foreign_key: true
  end
end
