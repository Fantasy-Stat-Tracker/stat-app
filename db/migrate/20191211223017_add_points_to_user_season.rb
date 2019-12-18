class AddPointsToUserSeason < ActiveRecord::Migration[5.2]
  def change
    add_column :user_seasons, :points, :float
    add_column :user_seasons, :regular_season_points, :float
    add_column :user_seasons, :playoff_points, :float
    add_column :user_seasons, :wins, :integer
    add_column :user_seasons, :losses, :integer
    add_column :user_seasons, :regular_season_wins, :integer
    add_column :user_seasons, :regular_season_losses, :integer
    add_column :user_seasons, :playoff_losses, :integer
    add_column :user_seasons, :playoff_wins, :integer
    add_column :user_seasons, :close_games, :integer
    add_column :user_seasons, :close_wins, :integer
    add_column :user_seasons, :close_losses, :integer
    add_column :user_seasons, :win_percentage, :float
  end
end
