class AddPointsPerGameToUserSeason < ActiveRecord::Migration[5.2]
  def change
    add_column :user_seasons, :points_per_game, :float
  end
end
