require "test_helper"

class BusTest < ActiveSupport::TestCase
  def setup
    # Create a Bus record for testing
    @bus = Bus.create!(
      bus_number: "12345",
      capacity: 50,
      status: "active",
      bus_color: "red"
    )
  end

  test "should save valid bus" do
    bus = Bus.new(
      bus_number: "67890",
      capacity: 40,
      status: "inactive",
      bus_color: "blue"
    )
    assert bus.save, "Bus with valid attributes should be saved"
  end

  test "should not save bus without bus_number" do
    bus = Bus.new(
      capacity: 40,
      status: "active",
      bus_color: "blue"
    )
    assert_not bus.save, "Saved the bus without a bus_number"
  end

  test "should not save bus without capacity" do
    bus = Bus.new(
      bus_number: "67890",
      status: "active",
      bus_color: "blue"
    )
    assert_not bus.save, "Saved the bus without a capacity"
  end

  test "should not save bus without status" do
    bus = Bus.new(
      bus_number: "67890",
      capacity: 40,
      bus_color: "blue"
    )
    assert_not bus.save, "Saved the bus without a status"
  end

  test "should not save bus without bus_color" do
    bus = Bus.new(
      bus_number: "67890",
      capacity: 40,
      status: "active"
    )
    assert_not bus.save, "Saved the bus without a bus_color"
  end

  test "should enforce unique bus_number" do
    duplicate_bus = Bus.new(
      bus_number: "12345", # Same as @bus
      capacity: 45,
      status: "inactive",
      bus_color: "green"
    )
    assert_not duplicate_bus.save, "Saved a bus with a duplicate bus_number"
  end

  test "should default status to active" do
    new_bus = Bus.create(
      bus_number: "98765",
      capacity: 30,
      bus_color: "yellow"
    )
    assert_equal "active", new_bus.status, "Status did not default to active"
  end
end
