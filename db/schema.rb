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

ActiveRecord::Schema.define(version: 20140601170605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "album_art_file_name"
    t.string   "album_art_content_type"
    t.integer  "album_art_file_size"
    t.datetime "album_art_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "band_id"
  end

  create_table "playlists", force: true do |t|
    t.string   "name"
    t.integer  "mood"
    t.integer  "timbre"
    t.integer  "intensity"
    t.integer  "tone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "songs_list", default: [],  array: true
    t.integer  "whitelist",  default: [0], array: true
    t.integer  "blacklist",  default: [0], array: true
    t.string   "scope"
  end

  create_table "songs", force: true do |t|
    t.string   "title"
    t.string   "mp3_file_name"
    t.string   "mp3_content_type"
    t.integer  "mp3_file_size"
    t.datetime "mp3_updated_at"
    t.string   "link_to_purchase"
    t.string   "link_to_download"
    t.integer  "average_mood"
    t.integer  "average_timbre"
    t.integer  "average_intensity"
    t.integer  "average_tone"
    t.integer  "mood",              default: [], array: true
    t.integer  "timbre",            default: [], array: true
    t.integer  "intensity",         default: [], array: true
    t.integer  "tone",              default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "album_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "role"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "user_pic_file_name"
    t.string   "user_pic_content_type"
    t.integer  "user_pic_file_size"
    t.datetime "user_pic_updated_at"
    t.boolean  "admin",                  default: false
    t.integer  "ratings",                default: [],                 array: true
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
