class AddTotalScoreToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :total_score, :float
  end
end
