class AdjustMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :reset_password_token
    remove_column :members, :reset_password_sent_at
    remove_column :members, :password_digest
    add_column :members, :team_name, :string
  end
end
