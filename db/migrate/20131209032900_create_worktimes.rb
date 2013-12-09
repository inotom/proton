class CreateWorktimes < ActiveRecord::Migration
  def change
    create_table :worktimes do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text     :memo
      t.integer  :work_id
      t.integer  :user_id

      t.timestamps
    end
    add_index :worktimes, [:work_id, :user_id, :start_time], unique: true
  end
end
