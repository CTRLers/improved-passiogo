class CreateRouteSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :route_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :route, null: false, foreign_key: true
      t.timestamps
    end

    add_index :route_subscriptions, [ :user_id, :route_id ], unique: true
  end
end
