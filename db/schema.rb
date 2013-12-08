# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131208210005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: true do |t|
    t.integer  "state_id"
    t.string   "name"
    t.string   "local_name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "local_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "following_relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "following_relationships", ["followed_user_id"], name: "index_following_relationships_on_followed_user_id", using: :btree
  add_index "following_relationships", ["follower_id"], name: "index_following_relationships_on_follower_id", using: :btree

  create_table "photo_shouts", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "shouts", force: true do |t|
    t.string   "content_type"
    t.integer  "content_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shouts", ["content_type", "content_id"], name: "index_shouts_on_content_type_and_content_id", using: :btree
  add_index "shouts", ["user_id"], name: "index_shouts_on_user_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "local_name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree

  create_table "subtrips", force: true do |t|
    t.integer  "trip_id"
    t.datetime "datetime"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subtrips", ["trip_id"], name: "index_subtrips_on_trip_id", using: :btree

  create_table "text_shouts", force: true do |t|
    t.string "body"
  end

  create_table "trips", force: true do |t|
    t.datetime "date"
    t.integer  "total_available_seats", default: 8
    t.string   "detail"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",     null: false
    t.string   "encrypted_password",                default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 50
    t.string   "last_sign_in_ip"
    t.integer  "city_id"
    t.string   "username",               limit: 50
    t.string   "firstname",              limit: 50
    t.string   "lastname",               limit: 50
    t.string   "gender",                 limit: 6,  default: "male", null: false
    t.string   "tel",                    limit: 20
    t.string   "mobile",                 limit: 20
    t.string   "address",                limit: 50
    t.string   "post_code",              limit: 10
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["city_id"], name: "index_users_on_city_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "vehicle_brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicle_models", force: true do |t|
    t.integer  "vehicle_brand_id"
    t.string   "name"
    t.integer  "seats_number"
    t.string   "default_image"
    t.string   "up_view_image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicle_models", ["vehicle_brand_id"], name: "index_vehicle_models_on_vehicle_brand_id", using: :btree

  create_table "vehicles", force: true do |t|
    t.integer  "user_id"
    t.integer  "vehicle_model_id"
    t.string   "color"
    t.string   "number_plate"
    t.boolean  "air_condition"
    t.date     "year"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicles", ["user_id"], name: "index_vehicles_on_user_id", using: :btree
  add_index "vehicles", ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id", using: :btree

end
