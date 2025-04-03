require 'test_helper'

class CreateBusesTest < ActiveSupport::TestCase
  def setup
    ActiveRecord::Base.connection.migrate
  end

  def teardown
    ActiveRecord::Base.connection.rollback_db_transaction
  end

  test "buses table should exist" do
    assert ActiveRecord::Base.connection.table_exists?(:buses), "Table 'buses' does not exist"
  end

  test "buses table should have correct columns" do
    columns = ActiveRecord::Base.connection.columns(:buses).map(&:name)
    assert_equal %w[id bus_number capacity status created_at updated_at], columns.sort
  end

  test "bus_number should be not null and unique" do
    column = ActiveRecord::Base.connection.columns(:buses).find { |c| c.name == "bus_number" }
    assert_not column.null, "bus_number should not allow NULL"

    index = ActiveRecord::Base.connection.indexes(:buses).find { |i| i.columns.include?("bus_number") }
    assert_not_nil index, "bus_number should have a unique index"
    assert index.unique, "bus_number index should be unique"
  end

  test "capacity should be not null" do
    column = ActiveRecord::Base.connection.columns(:buses).find { |c| c.name == "capacity" }
    assert_not column.null, "capacity should not allow NULL"
  end

  test "status should have a default value" do
    column = ActiveRecord::Base.connection.columns(:buses).find { |c| c.name == "status" }
    assert_not column.null, "status should not allow NULL"
    assert_equal "active", column.default, "status default value should be 'active'"
  end
end
