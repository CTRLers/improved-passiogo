require "test_helper"

class StopTest < ActiveSupport::TestCase
  def setup
    # Create a route with valid coordinates
    route = Route.create!(name: "Route for Stop", latitude: 40.123, longitude: -74.123)
    @stop = Stop.new(name: "Test Stop", latitude: 40.123, longitude: -74.123, route: route)
  end

  test "should be valid with valid attributes" do
    assert @stop.valid?
  end

  test "name should be present" do
    @stop.name = " "
    assert_not @stop.valid?, "Stop is valid without a name"
  end
end
