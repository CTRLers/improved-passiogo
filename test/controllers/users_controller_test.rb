require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_url, params: { user: {
        email: "new@example.com",
        password: "password",
        password_confirmation: "password",
        first_name: "John",
        last_name: "Doe"
      } }
    end
    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    user = users(:one)  # Ensure you have a fixture named 'one' in test/fixtures/users.yml
    get user_url(user)
    assert_response :success
  end

  test "should destroy user" do
    user = users(:one)
    assert_difference("User.count", -1) do
      delete user_url(user)
    end
    assert_redirected_to root_url  # Adjust if your destroy action redirects elsewhere
  end
end
