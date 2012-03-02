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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111021060743) do

  create_table "buildings", :force => true do |t|
    t.string   "building_name"
    t.integer  "occupants"
    t.integer  "capacity"
    t.integer  "area"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "building_type"
    t.string   "abbreviation"
  end

  create_table "electricity_readings", :force => true do |t|
    t.datetime "date_time"
    t.integer  "meter_id"
    t.float    "power"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meters", :force => true do |t|
    t.string   "ip"
    t.integer  "building_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weathers", :force => true do |t|
    t.datetime "today"
    t.float    "temperature"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end