require 'test_helper'

class CreateBusesTest < ActiveSupport::TestCase
  def setup
    ActiveRecord::Base.connection.migrate
  end

  def teardown
    ActiveRecord::Base.connection.rollback_db_transaction
  end

  test "buses table exists" do
    assert ActiveRecord::Base.connection.table_exists?(:buses), "Table 'buses' does not exist"
  end

  test "buses table has the correct columns" do
    expected_columns = {
      "id" => :integer,
      "bus_number" => :string,
      "capacity" => :integer,
      "status" => :string,
      "created_at" => :datetime,
      "updated_at" => :datetime
    }

    buses_columns = ActiveRecord::Base.connection.columns(:buses).map { |c| [c.name, c.type] }.to_h

    expected_columns.each do |col, type|
      assert_equal type, buses_columns[col], "Column '#{col}' should be of type #{type}"
    end
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
    assert_equal "active", column.default, "status default should be 'active'"
  end
end
