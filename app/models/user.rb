class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end