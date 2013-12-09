class Worktime < ActiveRecord::Base
  belongs_to :work
  default_scope -> { order('start_time DESC') }
  validates :start_time, presence: true
  validates :work_id   , presence: true
  validates :user_id   , presence: true

  def initialize(*args, &block)
    super
    self.start_time = Time.now if self.start_time.nil?
  end
end
