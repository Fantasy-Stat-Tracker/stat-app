class CreateWeeks < ActiveRecord::Migration[5.2]
  def change
    create_table :weeks do |t|
      t.integer :number
      t.references :season, foreign_key: true

      t.timestamps
    end
  end
end
