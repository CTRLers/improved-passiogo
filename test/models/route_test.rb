require "test_helper"

class RouteTest < ActiveSupport::TestCase
  def setup
    # Use latitude and longitude
    @route = Route.new(name: "Test Route", latitude: 40.123, longitude: -74.123)
  end

  test "should be valid with valid attributes" do
    assert @route.valid?
  end

  test "name should be present" do
    @route.name = " "
    assert_not @route.valid?, "Route is valid without a name"
  end

  test "name should be unique" do
    duplicate_route = @route.dup
    @route.save!
    assert_not duplicate_route.valid?, "Duplicate route with same name is valid"
  end
end
