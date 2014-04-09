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

ActiveRecord::Schema.define(version: 20140408224758) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: true do |t|
    t.integer  "user_id"
    t.integer  "subtrip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "acceptance_status", default: 0
  end

  add_index "bookings", ["subtrip_id"], name: "index_bookings_on_subtrip_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "branch_driver_relationships", force: true do |t|
    t.integer  "user_id"
    t.integer  "branch_id"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branch_driver_relationships", ["branch_id"], name: "index_branch_driver_relationships_on_branch_id", using: :btree
  add_index "branch_driver_relationships", ["user_id"], name: "index_branch_driver_relationships_on_user_id", using: :btree

  create_table "branches", force: true do |t|
    t.string   "name",               limit: 80
    t.string   "address"
    t.string   "email",              limit: 80
    t.string   "tel",                limit: 80
    t.string   "mobile",             limit: 80
    t.string   "city",               limit: 80
    t.string   "slug"
    t.float    "blat"
    t.float    "blng"
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "branches", ["company_id"], name: "index_branches_on_company_id", using: :btree
  add_index "branches", ["user_id"], name: "index_branches_on_user_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: true do |t|
    t.text     "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "companies", force: true do |t|
    t.string   "name",               limit: 80
    t.string   "tel",                limit: 80
    t.string   "email",              limit: 80
    t.string   "website",            limit: 80
    t.string   "slug"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "about"
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "contacts", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.boolean  "receiver_saw", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["receiver_id", "receiver_saw"], name: "index_contacts_on_receiver_id_and_receiver_saw", using: :btree
  add_index "contacts", ["receiver_id", "sender_id", "updated_at"], name: "index_contacts_on_receiver_id_and_sender_id_and_updated_at", using: :btree
  add_index "contacts", ["sender_id", "receiver_id", "updated_at"], name: "index_contacts_on_sender_id_and_receiver_id_and_updated_at", using: :btree

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "unit_price"
    t.integer  "price_step"
  end

  create_table "currency_translations", force: true do |t|
    t.integer  "currency_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "currency_translations", ["currency_id"], name: "index_currency_translations_on_currency_id", using: :btree
  add_index "currency_translations", ["locale"], name: "index_currency_translations_on_locale", using: :btree

  create_table "following_relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "following_relationships", ["followed_user_id"], name: "index_following_relationships_on_followed_user_id", using: :btree
  add_index "following_relationships", ["follower_id"], name: "index_following_relationships_on_follower_id", using: :btree

  create_table "invitations", force: true do |t|
    t.integer  "inviter_id"
    t.integer  "invited_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["invited_user_id"], name: "index_invitations_on_invited_user_id", using: :btree
  add_index "invitations", ["inviter_id"], name: "index_invitations_on_inviter_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "contact_id"
    t.text     "body"
    t.boolean  "hide4sender",   default: false
    t.boolean  "hide4receiver", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["contact_id"], name: "index_messages_on_contact_id", using: :btree

  create_table "page_translations", force: true do |t|
    t.integer  "page_id",    null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "content"
  end

  add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
  add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], name: "index_pages_on_permalink", using: :btree

  create_table "photo_shouts", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "body"
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

  create_table "spacial_events", force: true do |t|
    t.string   "title"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "permalink"
    t.integer  "origin_cycle"
    t.integer  "destination_cycle"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "olat"
    t.float    "olng"
    t.string   "origin_city",         limit: 50
    t.string   "origin_state",        limit: 50
    t.string   "origin_country",      limit: 50
    t.string   "origin_address"
    t.float    "dlat"
    t.float    "dlng"
    t.string   "destination_city",    limit: 50
    t.string   "destination_state",   limit: 50
    t.string   "destination_country", limit: 50
    t.string   "destination_address"
  end

  add_index "spacial_events", ["permalink"], name: "index_spacial_events_on_permalink", using: :btree

  create_table "subtrips", force: true do |t|
    t.integer  "trip_id"
    t.datetime "date_time"
    t.integer  "jyear"
    t.integer  "jmonth"
    t.integer  "jday"
    t.integer  "jhour"
    t.integer  "jminute"
    t.integer  "price"
    t.integer  "seats",                          default: [],   array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view",                           default: 0
    t.float    "olat"
    t.float    "olng"
    t.string   "origin_city",         limit: 50
    t.string   "origin_state",        limit: 50
    t.string   "origin_country",      limit: 50
    t.string   "origin_address"
    t.float    "dlat"
    t.float    "dlng"
    t.string   "destination_city",    limit: 50
    t.string   "destination_state",   limit: 50
    t.string   "destination_country", limit: 50
    t.string   "destination_address"
    t.string   "origin_country_code", limit: 5,  default: "IR"
    t.integer  "currency_id"
    t.boolean  "active",                         default: true
  end

  add_index "subtrips", ["date_time", "dlat", "dlng", "olat", "olng", "active"], name: "index_subtrips_on_date_time_and_dlatlng_and_olatolng_active", using: :btree
  add_index "subtrips", ["trip_id"], name: "index_subtrips_on_trip_id", using: :btree

  create_table "text_shouts", force: true do |t|
    t.string "body"
  end

  create_table "trips", force: true do |t|
    t.integer  "total_available_seats", default: 8
    t.text     "detail"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",           default: 1
    t.boolean  "ladies_only",           default: false
    t.integer  "groupid"
  end

  add_index "trips", ["groupid"], name: "index_trips_on_groupid", using: :btree
  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 50
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                             default: false
    t.string   "firstname",              limit: 50
    t.string   "lastname",               limit: 50
    t.string   "gender",                 limit: 6,                  null: false
    t.string   "tel",                    limit: 20
    t.string   "mobile",                 limit: 20
    t.string   "address"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "age"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "slug"
    t.boolean  "slug_updated",                      default: false
    t.string   "provider"
    t.string   "location"
    t.string   "uid"
    t.string   "facebook_image_url"
    t.float    "ulat"
    t.float    "ulng"
    t.string   "city",                   limit: 80
  end

  add_index "users", ["avatar_file_name"], name: "index_users_on_avatar_file_name", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree
  add_index "users", ["ulat", "ulng"], name: "index_users_on_ulat_and_ulng", using: :btree

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
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicles", ["user_id"], name: "index_vehicles_on_user_id", using: :btree
  add_index "vehicles", ["vehicle_model_id"], name: "index_vehicles_on_vehicle_model_id", using: :btree

end
