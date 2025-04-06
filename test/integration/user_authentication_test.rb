require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:confirmed_user)  # Make sure your fixture (e.g. confirmed_user) is set up properly
  end

  test "user can sign in with valid credentials" do
    get new_user_session_path
    assert_response :success

    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "password123"  # This should match your fixture password
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    # Instead of checking warden, verify via flash message and a sign-out indicator
    assert_equal "Signed in successfully.", flash[:notice]
    assert_select "a", text: /Profile/i
  end

  test "user cannot sign in with invalid credentials" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: "wrongpassword"
      }
    }
    # Devise returns a 422 Unprocessable Entity status on failure
    assert_response :unprocessable_entity
    assert_equal "Invalid Email or password.", flash[:alert]
    # Ensure that no sign-out link is present (indicating user is not signed in)
    assert_select "a", { count: 0, text: /Sign Out/i }
  end

  test "user can sign out" do
    sign_in @user
    delete destroy_user_session_path
    assert_redirected_to root_path
    follow_redirect!
    assert_equal "Signed out successfully.", flash[:notice]
  end

  test "user can register a new account" do
    get new_user_registration_path
    assert_response :success

    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "New",
          last_name: "User"
        }
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_equal "Welcome! You have signed up successfully.", flash[:notice]
  end

  test "user can request password reset" do
    get new_user_password_path
    assert_response :success

    post user_password_path, params: { user: { email: @user.email } }
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_equal "You will receive an email with instructions on how to reset your password in a few minutes.", flash[:notice]
  end

  test "user can update profile" do
    sign_in @user
    get edit_user_registration_path
    assert_response :success

    patch user_registration_path, params: {
      user: {
        first_name: "Updated",
        last_name: @user.last_name,  # Include required fields
        current_password: "password123"
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_equal "Your account has been updated successfully.", flash[:notice]
    assert_equal "Updated", @user.reload.first_name
  end
end
