class CreateCamps < ActiveRecord::Migration[7.2]
  def change
    create_table :camps do |t|
      t.string :name, null: false
      t.integer :capacity, null: false

      t.timestamps
    end
  end
end
