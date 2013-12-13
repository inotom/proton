class Todo < ActiveRecord::Base
  belongs_to :work
  default_scope -> { order('created_at DESC') }
  validates :work_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
end
