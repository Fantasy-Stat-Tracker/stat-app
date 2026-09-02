require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "redirects signed-in members to their league games" do
    league = League.create!(name: "Test League")
    user = User.create!(
      first_name: "Test",
      last_name: "User",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
    Member.create!(
      league: league,
      user: user,
      first_name: "Test",
      last_name: "Member",
      email: "member@example.com"
    )

    post login_path, params: { session: { email: user.email, password: "password" } }
    get root_path

    assert_redirected_to league_games_path(league)
  end
end
