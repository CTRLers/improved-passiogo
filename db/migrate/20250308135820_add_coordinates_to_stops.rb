class AddCoordinatesToStops < ActiveRecord::Migration[8.0]
  def change
    add_column :stops, :lat, :float
    add_column :stops, :long, :float
  end
end
