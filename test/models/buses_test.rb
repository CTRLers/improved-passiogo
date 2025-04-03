require "test_helper"

class BusTest < ActiveSupport::TestCase
  def setup
    @bus = Bus.new(bus_number: "12345", capacity: 50, status: "active", bus_color: "red")
  end

  test "should be valid with valid attributes" do
    assert @bus.valid?
  end

  test "should require a bus_number" do
    @bus.bus_number = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:bus_number], "can't be blank"
  end

  test "should require a capacity" do
    @bus.capacity = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:capacity], "can't be blank"
  end

  test "should require a status" do
    @bus.status = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:status], "can't be blank"
  end

  test "should require a bus_color" do
    @bus.bus_color = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:bus_color], "can't be blank"
  end

  test "should enforce unique bus_number" do
    @bus.save
    duplicate_bus = @bus.dup
    assert_not duplicate_bus.valid?
    assert_includes duplicate_bus.errors[:bus_number], "has already been taken"
  end

  test "should default status to active" do
    new_bus = Bus.create(bus_number: "67890", capacity: 40, bus_color: "blue")
    assert_equal "active", new_bus.status
  end
end
