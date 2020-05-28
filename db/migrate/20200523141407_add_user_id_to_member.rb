class AddUserIdToMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :user, foreign_key: true
  end
end
