class Work < ActiveRecord::Base
  belongs_to :user
  has_many :worktimes, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }

  scope :titled, ->(q) { where 'title like ?', "%#{q}%" }

  def total_worktimes
    total = 0
    self.worktimes.each do |worktime|
      unless worktime.end_time.nil? || worktime.start_time.nil?
        total += worktime.end_time - worktime.start_time
      end
    end
    total
  end
end
