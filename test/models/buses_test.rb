require 'test_helper'

class BusTest < ActiveSupport::TestCase
  def setup
    @bus = Bus.new(bus_number: "123ABC", capacity: 50, status: "active", bus_color: "red")
  end

  test "should be valid with all fields" do
    assert @bus.valid?
  end

  test "bus_number should be present" do
    @bus.bus_number = nil
    assert_not @bus.valid?, "Saved the bus without a bus_number"
  end

  test "bus_number should be unique" do
    duplicate_bus = @bus.dup
    @bus.save
    assert_not duplicate_bus.valid?, "Allowed duplicate bus_number"
  end

  test "capacity should be present" do
    @bus.capacity = nil
    assert_not @bus.valid?, "Saved the bus without a capacity"
  end

  test "capacity should be a number" do
    @bus.capacity = "abc"
    assert_not @bus.valid?, "Allowed non-numeric capacity"
  end

  test "status should have a default value" do
    new_bus = Bus.create(bus_number: "456DEF", capacity: 40, bus_color: "blue")
    assert_equal "active", new_bus.status, "Default status is not 'active'"
  end

  test "bus_color should be present" do
    @bus.bus_color = nil
    assert_not @bus.valid?, "Saved the bus without a bus_color"
  end
end
