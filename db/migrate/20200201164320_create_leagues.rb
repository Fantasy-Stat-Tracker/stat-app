class CreateLeagues < ActiveRecord::Migration[5.2]
  def change
    create_table :leagues do |t|
      t.integer :start_year
      t.string :espn_s2
      t.string :swid
      t.integer :total_members_count
      t.integer :active_members_count

      t.timestamps
    end
  end
end
