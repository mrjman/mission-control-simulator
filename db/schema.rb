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

ActiveRecord::Schema.define(version: 20180304201627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tokens", force: :cascade do |t|
    t.string "access_token"
    t.string "client_id"
    t.string "client_secret"
    t.datetime "access_token_created_at"
    t.string "access_token_type"
    t.string "access_token_scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest", null: false
    t.string "city"
    t.string "gender"
    t.integer "weight"
    t.float "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "token_id"
    t.index ["token_id"], name: "index_users_on_token_id"
  end

  add_foreign_key "users", "tokens"
end
