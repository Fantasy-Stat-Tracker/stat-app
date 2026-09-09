require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "shows the password reset form" do
    get new_password_reset_url
    assert_response :success
  end

  test "sends password reset instructions for a matching email address" do
    user = User.create!(
      first_name: "Test",
      last_name: "User",
      email: "reset@example.com",
      password: "password",
      password_confirmation: "password"
    )

    assert_emails 1 do
      post password_resets_url, params: { email: user.email }
    end

    assert_redirected_to root_url
    user.reload
    assert_not_nil user.reset_password_token
    assert_not_nil user.reset_password_sent_at

    email = ActionMailer::Base.deliveries.last
    assert_equal [user.email], email.to
    assert_equal "Reset password instructions", email.subject
    assert_includes email.body.to_s, edit_password_reset_path(user.reset_password_token)
  end
end
