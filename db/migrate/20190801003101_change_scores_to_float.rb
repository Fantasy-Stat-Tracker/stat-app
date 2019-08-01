class ChangeScoresToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :games, :home_score, :float
    change_column :games, :away_score, :float
  end
end
