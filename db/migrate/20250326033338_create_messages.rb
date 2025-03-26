class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :message_type
      t.text :content
      t.references :messageable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
