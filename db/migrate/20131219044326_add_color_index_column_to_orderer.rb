class AddColorIndexColumnToOrderer < ActiveRecord::Migration
  def change
    add_column :orderers, :color_index, :integer, :default => 1
  end
end
