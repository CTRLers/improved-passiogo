require "test_helper"

class BusTest < ActiveSupport::TestCase
  # Set up a valid bus for reuse in tests
  def setup
    @bus = Bus.new(bus_number: "123", capacity: 50, status: "active", bus_color: "red")
  end

  # Test that a bus with valid attributes can be saved
  test "should save valid bus" do
    assert @bus.save, "Could not save a valid bus"
  end

  # Test that a bus cannot be saved without a bus_number
  test "should not save bus without bus_number" do
    @bus.bus_number = nil
    assert_not @bus.save, "Saved the bus without a bus_number"
  end

  # Test that a bus cannot be saved without a capacity
  test "should not save bus without capacity" do
    @bus.capacity = nil
    assert_not @bus.save, "Saved the bus without a capacity"
  end

  # Test that a bus cannot be saved with a negative capacity
  test "should not save bus with negative capacity" do
    @bus.capacity = -5
    assert_not @bus.save, "Saved the bus with a negative capacity"
  end

  # Test that a bus cannot be saved without a bus_color
  test "should not save bus without bus_color" do
    @bus.bus_color = nil
    assert_not @bus.save, "Saved the bus without a bus_color"
  end

  # Test that a bus cannot be saved with an invalid status
  test "should not save bus with invalid status" do
    @bus.status = "broken"
    assert_not @bus.save, "Saved the bus with an invalid status"
  end

  # Test that a bus with a valid status can be saved
  test "should save bus with valid status" do
    valid_statuses = ["active", "inactive", "maintenance"]
    valid_statuses.each do |status|
      @bus.status = status
      assert @bus.save, "Could not save the bus with valid status #{status}"
    end
  end

  # Test that a bus number must be unique
  test "should not save bus with duplicate bus_number" do
    duplicate_bus = @bus.dup
    @bus.save
    assert_not duplicate_bus.save, "Saved the bus with a duplicate bus_number"
  end
end
