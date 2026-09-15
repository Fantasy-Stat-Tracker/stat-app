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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "normalizes email before validation" do
    user = User.create!(email: "  New.User@Example.COM ", password: "password123")

    assert_equal "new.user@example.com", user.email
  end

  test "requires a unique email regardless of case" do
    User.create!(email: "person@example.com", password: "password123")
    duplicate = User.new(email: "PERSON@example.com", password: "password123")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "requires a valid email address" do
    user = User.new(email: "not-an-email", password: "password123")

    assert_not user.valid?
    assert_includes user.errors[:email], "is invalid"
  end

  test "requires a password with at least eight characters" do
    user = User.new(email: "person@example.com", password: "short")

    assert_not user.valid?
    assert_includes user.errors[:password], "is too short (minimum is 8 characters)"
  end
end
