class Work < ActiveRecord::Base
  belongs_to :user
  has_many :worktimes, dependent: :destroy
  has_many :todos, dependent: :destroy
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

  def payment_rate
    pay_rt = 0
    if self.payment.nil? || self.payment.blank?
      payment = 0
    else
      payment = self.payment
    end

    if self.total_worktimes > 0
      pay_rt = payment / (self.total_worktimes / 60 / 60)
    end
    pay_rt.round
  end
end
