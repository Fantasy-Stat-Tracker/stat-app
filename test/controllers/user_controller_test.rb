require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "shows the signup form" do
    get signup_path

    assert_response :success
    assert_select "h1", "Create your account"
    assert_select "input[name='user[email]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']", count: 0
    assert_select "input#login-modal.modal-toggle", count: 1
    assert_select "label[for='login-modal']", text: "Login"
    assert_select "label[for='login-modal']", text: "Log in."
    assert_select "form[action='#{login_path}']"
  end

  test "creates and signs in a user" do
    assert_difference("User.count", 1) do
      post signup_path, params: {
        user: {
          email: "  NEW.USER@Example.com ",
          password: "password123"
        }
      }
    end

    assert_redirected_to users_path
    follow_redirect!
    assert_response :success
    assert_select "[role='status']", text: /Your account has been created/
    assert_select "a", text: "Logout"
    assert_select "main", text: ""
    assert_equal "new.user@example.com", User.order(:created_at).last.email
  end

  test "requires an account to view the user index" do
    get users_path

    assert_redirected_to root_path
  end

  test "does not create a user when the password is too short" do
    assert_no_difference("User.count") do
      post signup_path, params: {
        user: {
          email: "new.user@example.com",
          password: "short"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "[role='alert']", text: /Password is too short/
  end
end
