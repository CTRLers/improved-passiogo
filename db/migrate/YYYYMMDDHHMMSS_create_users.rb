#
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      # Basic user information
      t.string :email, null: false
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      
      # Push notification token
      t.string :fcm_token
      
      # User preferences (for notification settings)
      t.jsonb :preferences, default: {}
      
      # Standard timestamps
      t.timestamps
      
      # Reset password fields (if needed)
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      
      # Remember me feature (if needed)
      t.datetime :remember_created_at
    end
    
    # Add indexes
    add_index :users, :email, unique: true
    add_index :users, :fcm_token, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
