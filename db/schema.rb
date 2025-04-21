# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_10_161920) do
  create_table "buses", force: :cascade do |t|
    t.string "bus_number", null: false
    t.integer "capacity", null: false
    t.string "status", default: "active", null: false
    t.string "bus_color", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_number"], name: "index_buses_on_bus_number", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.string "message_type"
    t.text "content"
    t.string "messageable_type", null: false
    t.integer "messageable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable"
  end

  create_table "route_subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route_id"], name: "index_route_subscriptions_on_route_id"
    t.index ["user_id", "route_id"], name: "index_route_subscriptions_on_user_id_and_route_id", unique: true
    t.index ["user_id"], name: "index_route_subscriptions_on_user_id"
  end

  create_table "routes", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "lat"
    t.float "long"
    t.index ["name"], name: "index_routes_on_name", unique: true
  end

  create_table "stop_subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "stop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stop_id"], name: "index_stop_subscriptions_on_stop_id"
    t.index ["user_id", "stop_id"], name: "index_stop_subscriptions_on_user_id_and_stop_id", unique: true
    t.index ["user_id"], name: "index_stop_subscriptions_on_user_id"
  end

  create_table "stops", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.integer "route_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "lat"
    t.float "long"
    t.index ["route_id"], name: "index_stops_on_route_id"
  end

  create_table "user_notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "notification_type", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.json "data", default: {}
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type"], name: "index_user_notifications_on_notification_type"
    t.index ["user_id", "read_at"], name: "index_user_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_user_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "fcm_token"
    t.json "preferences", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "driver", default: false, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["fcm_token"], name: "index_users_on_fcm_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "route_subscriptions", "routes"
  add_foreign_key "route_subscriptions", "users"
  add_foreign_key "stop_subscriptions", "stops"
  add_foreign_key "stop_subscriptions", "users"
  add_foreign_key "stops", "routes"
  add_foreign_key "user_notifications", "users"
end
