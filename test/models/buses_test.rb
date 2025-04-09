require "test_helper"

class BusTest < ActiveSupport::TestCase
  def setup
    @bus = Bus.new(
      bus_number: "A100",
      capacity: 50,
      status: "active",
      bus_color: "blue"
    )
  end

  test "should be valid with valid attributes" do
    assert @bus.valid?
  end

  test "should require a bus_number" do
    @bus.bus_number = ""
    assert_not @bus.valid?
    assert_includes @bus.errors[:bus_number], "can't be blank"
  end

  test "should require a unique bus_number" do
    @bus.save!
    duplicate = @bus.dup
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:bus_number], "has already been taken"
  end

  test "should require capacity" do
    @bus.capacity = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:capacity], "can't be blank"
  end

  test "should require capacity to be a positive integer" do
    @bus.capacity = -5
    assert_not @bus.valid?
    assert_includes @bus.errors[:capacity], "must be greater than 0"

    @bus.capacity = 2.5
    assert_not @bus.valid?
    assert_includes @bus.errors[:capacity], "must be an integer"

    @bus.capacity = "large"
    assert_not @bus.valid?
  end

  test "should require status" do
    @bus.status = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:status], "can't be blank"
  end

  test "should only allow valid status values" do
    @bus.status = "flying"
    assert_not @bus.valid?
    assert_includes @bus.errors[:status], "is not included in the list"
  end

  test "should allow valid status values" do
    ["active", "inactive", "maintenance"].each do |valid_status|
      @bus.status = valid_status
      assert @bus.valid?, "#{valid_status} should be valid"
    end
  end

  test "should default status to active if not set" do
    bus = Bus.create!(
      bus_number: "B200",
      capacity: 40,
      bus_color: "green"
    )
    assert_equal "active", bus.status
  end

  test "should require a bus_color" do
    @bus.bus_color = nil
    assert_not @bus.valid?
    assert_includes @bus.errors[:bus_color], "can't be blank"
  end
end
