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

ActiveRecord::Schema.define(version: 20150516083214) do

  create_table "adapters", force: :cascade do |t|
    t.string   "name"
    t.integer  "wifi"
    t.integer  "internet_source"
    t.string   "ip_adress"
    t.string   "mask"
    t.integer  "security"
    t.integer  "dhcp"
    t.string   "ssid"
    t.string   "password"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "environments", force: :cascade do |t|
    t.string   "operating_system", limit: 255
    t.string   "current_version",  limit: 255
    t.integer  "adapter_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
