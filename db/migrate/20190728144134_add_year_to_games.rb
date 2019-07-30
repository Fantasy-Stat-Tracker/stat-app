class AddYearToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :year, :integer
  end
end
