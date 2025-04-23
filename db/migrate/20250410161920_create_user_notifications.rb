class CreateUserNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.json :data, default: {}
      t.datetime :read_at
      t.timestamps
    end

    add_index :user_notifications, [ :user_id, :read_at ]
    add_index :user_notifications, :notification_type
  end
end
