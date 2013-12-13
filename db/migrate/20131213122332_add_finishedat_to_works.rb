class AddFinishedatToWorks < ActiveRecord::Migration
  def change
    add_column :works, :finished_at, :datetime
  end
end
