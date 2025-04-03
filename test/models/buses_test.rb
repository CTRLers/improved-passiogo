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
    assert_includes columns, "bus_number"
    assert_includes columns, "capacity"
    assert_includes columns, "status"
    assert_includes columns, "created_at"
    assert_includes columns, "updated_at"
  end

  test "bus_number should be unique and not null" do
    column = ActiveRecord::Base.connection.columns(:buses).find { |c| c.name == "bus_number" }
    assert_not column.null, "bus_number should not allow NULL"
  end

  test "capacity should be not null" do
    column = ActiveRecord::Base.connection.columns(:buses).find { |c| c.name == "capacity" }
    assert_not column.null, "capacity should not allow NULL"
  end

  test "status should have a default value" do
    default_value = ActiveRecord::Base.connection.columns(:buses).find { |c| c.name == "status" }.default
    assert_equal "active", default_value, "status default value should be 'active'"
  end
end
