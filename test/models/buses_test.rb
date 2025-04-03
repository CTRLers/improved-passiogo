require 'test_helper'

class BusesTest < ActiveSupport::TestCase
  # Setup method to create a valid bus instance before each test
  def setup
    @bus = Bus.new(bus_number: '12345', capacity: 50, status: 'active', bus_color: 'red')
  end

  # Test that the bus is valid with all fields filled
  test "should be valid with all fields" do
    assert @bus.valid?
  end

  # Test that bus number cannot be empty
  test "bus number should be present" do
    @bus.bus_number = " "
    assert_not @bus.valid?
  end

  # Test that bus number should be unique
  test "bus number should be unique" do
    duplicate_bus = @bus.dup
    @bus.save
    assert_not duplicate_bus.valid?
  end

  # Test that capacity should be present
  test "capacity should be present" do
    @bus.capacity = nil
    assert_not @bus.valid?
  end

  # Test that capacity should be a number
  test "capacity should be a number" do
    @bus.capacity = "abc"
    assert_not @bus.valid?
  end

  # Test that bus color should be present
  test "bus color should be present" do
    @bus.bus_color = " "
    assert_not @bus.valid?
  end

  # Test that the status field has a default value of 'active'
  test "status should have a default value" do
    bus = Bus.new(bus_number: '54321', capacity: 30, bus_color: 'blue')
    assert_equal 'active', bus.status
  end
end
