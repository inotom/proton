class RemoveUserIdFromWorktimes < ActiveRecord::Migration
  def change
    remove_columns :worktimes, :user_id
  end
end
