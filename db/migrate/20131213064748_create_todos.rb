class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title
      t.boolean :status, null: false, default: false
      t.integer :work_id

      t.timestamps
    end
    add_index :todos, [:work_id, :created_at]
  end
end
