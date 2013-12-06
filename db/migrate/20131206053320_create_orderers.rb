class CreateOrderers < ActiveRecord::Migration
  def change
    create_table :orderers do |t|
      t.string  :name
      t.integer :user_id

      t.timestamps
    end
    add_index :orderers, [:user_id]
  end
end
