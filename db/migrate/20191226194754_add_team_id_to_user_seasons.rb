class AddTeamIdToUserSeasons < ActiveRecord::Migration[5.2]
  def change
    add_column :user_seasons, :espn_team_id, :string
  end
end
