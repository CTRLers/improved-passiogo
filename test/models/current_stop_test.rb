# test/models/current_stop_test.rb
require "test_helper"

class CurrentStopTest < ActiveSupport::TestCase
  test "should be optional for route" do
    route = routes(:one)
    assert_nil route.current_stop
  end

  test "can assign a valid stop as current_stop" do
    route = routes(:one)
    stop = stops(:one)
    route.current_stop = stop
    assert route.save
    assert_equal stop, route.reload.current_stop
  end
end
