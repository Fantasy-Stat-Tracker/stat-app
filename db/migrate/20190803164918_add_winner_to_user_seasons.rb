class AddWinnerToUserSeasons < ActiveRecord::Migration[5.2]
  def change
    add_column :user_seasons, :is_winner, :boolean
  end
end
