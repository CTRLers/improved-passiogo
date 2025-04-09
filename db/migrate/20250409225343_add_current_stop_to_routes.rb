class AddCurrentStopToRoutes < ActiveRecord::Migration[8.0]
  def change
    add_column :routes, :current_stop_id, :integer
  end
end
