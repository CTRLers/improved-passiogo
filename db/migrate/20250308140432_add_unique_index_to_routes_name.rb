class AddUniqueIndexToRoutesName < ActiveRecord::Migration[8.0]
  def change
    add_index :routes, :name, unique: true
  end
end
