class ChangePlayersToUsers < ActiveRecord::Migration[5.2]
  def change
    rename_table :players, :users
  end
end
