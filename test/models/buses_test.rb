require "test_helper"

class BusTest < ActiveSupport::TestCase
  def setup
    @bus = Bus.new(name: "Downtown Express", capacity: 40, route_number: "D10")
  end

  test "should be valid with valid attributes" do
    assert @bus.valid?
  end

  test "should require a name" do
    @bus.name = ""
    assert_not @bus.valid?
    assert_includes @bus.errors[:name], "can't be blank"
  end

  test "should require a positive integer capacity" do
    @bus.capacity = -5
    assert_not @bus.valid?
    assert_includes @bus.errors[:capacity], "must be greater than 0"

    @bus.capacity = 0
    assert_not @bus.valid?

    @bus.capacity = 2.5
    assert_not @bus.valid?

    @bus.capacity = "forty"
    assert_not @bus.valid?
  end

  test "should require a unique route_number" do
    @bus.save!
    duplicate_bus = Bus.new(name: "Uptown Express", capacity: 30, route_number: "D10")
    assert_not duplicate_bus.valid?
    assert_includes duplicate_bus.errors[:route_number], "has already been taken"
  end
end
