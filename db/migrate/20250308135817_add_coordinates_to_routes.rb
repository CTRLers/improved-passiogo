class AddCoordinatesToRoutes < ActiveRecord::Migration[8.0]
  def change
    add_column :routes, :lat, :float
    add_column :routes, :long, :float
  end
end
