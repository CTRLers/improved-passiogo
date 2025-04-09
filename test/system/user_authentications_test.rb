require "application_system_test_case"

class UserAuthenticationSystemTest < ApplicationSystemTestCase
  def setup
    @user = users(:confirmed_user)  # Ensure your fixture "confirmed_user" is defined with password "password123"
  end

  test "user can sign in and sign out system" do
    visit new_user_session_path
    # Verify we're on the sign in page
    assert_text("Sign in")

    fill_in "Email Address", with: @user.email
    fill_in "Password", with: "password123"
    click_button "Log in"

    # After sign in, expect an element that indicates the user is logged in.
    # For example, if your layout shows a "Profile" button when signed in:
    assert_text("Profile")
    click_button("Profile")

    # Now, sign out by clicking the "Sign Out" link.
    assert_text("Sign Out")
    click_button "Sign Out"
    # After sign out, we expect to see a "Sign In" link or text.
    assert_text("Sign In")
  end

  test "user cannot sign in with invalid credentials system" do
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "wrongpassword"
    click_button "Log in"

    # Expect to remain on the sign in page with an error message.
    #  TODO: create an invalid email or password alert
    # assert_text("Invalid Email or password")
    # Verify that "Sign in" text is still visible.
    assert_text("Sign in")
  end

  test "user can register a new account system" do
    visit new_user_registration_path

    fill_in "user_email", with: "newuser@example.com"
    fill_in "user_password", with: "password123"
    # Use the label as it appears on your form; try "Password Confirmation" if "Password confirmation" isn't found.
    fill_in "user_password_confirmation", with: "password123"
    fill_in "user_first_name", with: "New"
    fill_in "user_last_name", with: "User"
    click_button "commit"

    # Expect a welcome message. Adjust the expected text to match your flash or page content.
    # assert_text("Welcome! You have signed up successfully")
    # TODO add a Welcome message after signing up

    assert_text("Dashboard")
  end

  test "user can request a password reset system" do
    visit new_user_password_path

    fill_in "user_email", with: @user.email
    click_button "Send me reset password instructions"

    # Expect a message confirming the reset email has been sent.
    # TODO: feedback on how to reset
    # assert_text("You will receive an email with instructions")

    assert_text("Sign in")
  end
end
