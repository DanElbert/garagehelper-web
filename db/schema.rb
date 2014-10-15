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

ActiveRecord::Schema.define(version: 20141015183414) do

  create_table "garage_updates", force: true do |t|
    t.boolean  "big_door_open"
    t.boolean  "back_door_open"
    t.boolean  "basement_door_open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_change"
  end

  add_index "garage_updates", ["created_at", "is_change"], name: "index_garage_updates_on_created_at_and_is_change"

end
