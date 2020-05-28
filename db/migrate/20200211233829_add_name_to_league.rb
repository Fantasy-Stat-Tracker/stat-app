class AddNameToLeague < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :name, :string
  end
end
