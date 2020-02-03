class ChangeUserIdToMemberId < ActiveRecord::Migration[5.2]
  def change
    rename_column :member_seasons, :user_id, :member_id
  end
end
