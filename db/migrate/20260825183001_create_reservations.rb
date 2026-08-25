class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :camp, null: false, foreign_key: true, index: false
      t.string :name, null: false
      t.integer :amount, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end

    add_index :reservations, [ :camp_id, :start_date, :end_date ]
  end
end
