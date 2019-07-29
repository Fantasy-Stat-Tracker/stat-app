class AddWeekNumberToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :week_number, :integer
  end
end
