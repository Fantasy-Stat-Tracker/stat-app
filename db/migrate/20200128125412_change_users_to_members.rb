class ChangeUsersToMembers < ActiveRecord::Migration[5.2]
  def change
    rename_table :users, :members
    rename_table :user_seasons, :member_seasons
  end
end
