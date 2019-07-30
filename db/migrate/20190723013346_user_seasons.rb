class UserSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :user_seasons do |t|
      t.references :user, index: true, foreign_key: true
      t.references :season, index: true, foreign_key: true
    end
  end
end
