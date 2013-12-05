class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string  :title
      t.decimal :payment
      t.text    :other
      t.boolean :finished  , :default => false
      t.boolean :claimed   , :default => false
      t.boolean :receipted , :default => false
      t.integer :user_id
      t.integer :orderer_id, :default => 0

      t.timestamps
    end
    # user id に関連付けられた work データを作成日時でソートするために
    # index を付与する
    add_index :works, [:user_id, :created_at]
  end
end
