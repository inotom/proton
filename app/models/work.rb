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

  def worktimes_chart
    chart = { earlymorning: 0, morning: 0, noon: 0, evening: 0, night: 0, midnight: 0 }
    self.worktimes.each do |worktime|
      unless worktime.end_time.nil?
        worktime_zones(worktime).each do |zone|
          chart[zone] += 1
        end
      end
    end
    chart
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

  private

    def worktime_zones(worktime)
      from = worktime.start_time.hour
      to   = from + ((worktime.end_time - worktime.start_time) / 60 / 60)
      zones = Array.new
      (from..to).to_a.each do |hour|
        hour = hour - 24 if hour > 24
        zones.push(get_zones(hour))
      end
      zones
    end

    def get_zones(hour)
      case
      when hour >= 2  && hour < 6
        :earlymorning
      when hour >= 6  && hour < 10
        :morning
      when hour >= 10 && hour < 14
        :noon
      when hour >= 14 && hour < 18
        :evening
      when hour >= 18 && hour < 22
        :night
      else
        :midnight
      end
    end
end
