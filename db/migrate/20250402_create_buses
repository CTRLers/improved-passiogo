class CreateBuses < ActiveRecord::Migration[8.0]
  def change
    create_table :buses do |t|
      t.string :bus_number, null: false  # Unique constraint will be added separately
      t.integer :capacity, null: false
      t.string :status, default: 'active', null: false
      t.string :bus_color, null: false  # New column for bus color

      t.timestamps
    end

    add_index :buses, :bus_number, unique: true # Enforce uniqueness at the database level
  end
end
