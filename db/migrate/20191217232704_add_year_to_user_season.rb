class AddYearToUserSeason < ActiveRecord::Migration[5.2]
  def change
    add_column :user_seasons, :year, :integer
  end
end
