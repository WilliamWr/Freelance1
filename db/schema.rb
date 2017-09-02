# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170902034335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.text "message"
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "move_out_date", null: false
    t.string "move_out_location", null: false
    t.string "move_out_room", null: false
    t.string "move_out_other"
    t.datetime "move_in_date", null: false
    t.string "move_in_location", null: false
    t.string "move_in_room", null: false
    t.string "move_in_other"
    t.json "storage_items"
    t.boolean "confirm_other", default: false, null: false
    t.boolean "registration_fee_paid", default: false
    t.datetime "registration_fee_paid_date"
    t.integer "moving_box_total"
    t.decimal "moving_box_amount"
    t.integer "package_tape_total"
    t.decimal "package_tape_amount"
    t.integer "package_mattress_total"
    t.decimal "package_mattress_amount"
    t.integer "package_bubble_wrap_total"
    t.decimal "package_bubble_wrap_amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_token"
    t.decimal "amount"
    t.index ["confirm_other"], name: "index_purchases_on_confirm_other"
    t.index ["registration_fee_paid"], name: "index_purchases_on_registration_fee_paid"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.string "middleinitial"
    t.string "lastname"
    t.string "schoolname"
    t.integer "schoolyear"
    t.string "parentfirstname"
    t.string "parentmiddleinitial"
    t.string "parentlastname"
    t.string "parentemail"
    t.string "studentphonenumber"
    t.string "parentphonenumber"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "purchases", "users"
end
