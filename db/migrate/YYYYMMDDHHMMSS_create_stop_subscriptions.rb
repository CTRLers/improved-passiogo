#
class CreateStopSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :stop_subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stop, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :stop_subscriptions, [:user_id, :stop_id], unique: true
  end
end
