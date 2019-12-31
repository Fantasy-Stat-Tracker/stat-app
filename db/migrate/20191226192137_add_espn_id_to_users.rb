class AddEspnIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :espn_id, :string
  end
end
