class AddAssociationsForDriverAndRoute < ActiveRecord::Migration[6.1]
  def change
    add_reference :routes, :current_stop, foreign_key: { to_table: :stops }, null: true
    add_reference :users, :active_route, foreign_key: { to_table: :routes }, null: true
  end
end
