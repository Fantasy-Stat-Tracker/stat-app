require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "an account without a league can log in" do
    User.create!(email: "person@example.com", password: "password123")

    post login_path, params: {
      session: { email: " PERSON@EXAMPLE.COM ", password: "password123" }
    }

    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_select "[role='status']", text: "Welcome back!"
    assert_select "a", text: "Logout"
  end
end
