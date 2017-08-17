class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.timestamp :move_out_date,  null: false
      t.string :move_out_location,  null: false
      t.string :move_out_room,      null: false
      t.string :move_out_room,      null: false
      t.string :move_out_other

      t.timestamp :move_in_date,   null: false
      t.string :move_in_location,   null: false
      t.string :move_in_room,       null: false
      t.string :move_in_other

      t.json :storage_items

      t.boolean :confirm_other,           null: false, default: false

      t.boolean :registration_fee_paid,   default: false
      t.timestamp :registration_fee_paid_date

      t.integer :moving_box_total
      t.decimal :moving_box_amount

      t.integer :package_tape_total
      t.decimal :package_tape_amount

      t.integer :package_mattress_total
      t.decimal :package_mattress_amount

      t.integer :package_bubble_wrap_total
      t.decimal :package_bubble_wrap_amount

      t.belongs_to :user, foreign_key: true

     t.timestamps
    end
    add_index(:purchases, [:registration_fee_paid])
    add_index(:purchases, [:confirm_other])
  end
end
