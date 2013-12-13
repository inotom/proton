class User < ActiveRecord::Base
  has_many :works, dependent: :destroy
  has_many :orderers, dependent: :destroy
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  validates :name , presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password_confirmation, presence: true
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def total_payments
    total = Hash.new
    self.works.each do |work|
      next unless work.finished

      year = work.updated_at.year.to_s
      unless total.key?(year)
        total[year] = work.payment if work.payment
      else
        total[year] += work.payment if work.payment
      end
    end
    total
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
