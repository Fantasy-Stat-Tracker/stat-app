class AddLeagueRefToMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :league, foreign_key: true
  end
end
