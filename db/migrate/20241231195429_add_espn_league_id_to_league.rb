class AddEspnLeagueIdToLeague < ActiveRecord::Migration[8.0]
  def change
    add_column :leagues, :espn_league_id, :string
  end
end
