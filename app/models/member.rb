class Member < ApplicationRecord
  has_secure_password
  has_many :member_seasons
  has_many :seasons, through: :member_seasons
  has_many :home_games, class_name: 'Game', foreign_key: 'home_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_id'
  has_many :winning_games, class_name: 'Game', foreign_key: 'winner_id'
  has_many :losing_games, class_name: 'Game', foreign_key: 'loser_id'
  validates :email, presence: true

  before_create :set_full_name

  def full_name
    "#{first_name} #{last_name}"
  end

  def games
    self.home_games.to_a + self.away_games.to_a
  end

  def total_win_loss
    "#{self.winning_games.count} - #{self.losing_games.count}"
  end

  def win_percentage
    self.winning_games.count / (self.winning_games.count + self.losing_games.count).to_f
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

  private

  def set_full_name
    self.full_name = "#{first_name} #{last_name}"
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  first_name             :string
#  last_name              :string
#  email                  :string
#  password_digest        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#
