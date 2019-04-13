class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :week, foreign_key: true
      t.integer :home_score
      t.integer :away_score
      t.integer :home_id
      t.integer :away_id
      t.integer :winner_id
      t.integer :loser_id

      t.timestamps
    end
  end
end
