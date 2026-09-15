class User < ApplicationRecord
  has_secure_password
  has_many :members
  before_validation :normalize_email

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_nil: true

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def send_password_reset
    generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.forgot_password(self).deliver# This sends an e-mail with a link for the user to reset the password
  end
  # This generates a random password reset token for the user
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
end
