class AddEraToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :era, :string, default: "new"
  end
end
