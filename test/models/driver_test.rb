require "test_helper"

class DriverTest < ActiveSupport::TestCase
  # Load fixtures from the drivers fixture (including our driver fixture)
  fixtures :drivers

  test "fixture driver should be valid" do
    driver = drivers(:driver)
    assert driver.valid?, "Fixture driver should be valid"
  end


  test "should have driver flag set to true" do
    driver = drivers(:driver)
    if driver.has_attribute?(:driver)
      assert driver.driver, "Driver flag should be true"
    else
      skip "Driver flag attribute not present"
    end
  end

  test "should not allow driver without email" do
    invalid_driver = Driver.new(password: "password123")
    assert_not invalid_driver.valid?, "Driver without email should be invalid"
    assert_includes invalid_driver.errors.full_messages, "Email can't be blank"
  end

  test "should not allow driver with short password" do
    invalid_driver = Driver.new(email: "invalid@example.com", password: "short")
    assert_not invalid_driver.valid?, "Driver with short password should be invalid"
    assert_includes invalid_driver.errors.full_messages, "Password is too short (minimum is 8 characters)"
  end
end
