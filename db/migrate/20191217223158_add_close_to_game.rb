class AddCloseToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :close, :boolean
  end
end
