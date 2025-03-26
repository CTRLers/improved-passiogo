class AddDriverFlagToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :driver, :boolean, default: false, null: false
  end
end
