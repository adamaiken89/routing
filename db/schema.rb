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

ActiveRecord::Schema.define(version: 20180222092010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "routing_infos", force: :cascade do |t|
    t.string "token"
    t.json "routing_input"
    t.bigint "driving_distance_in_meters"
    t.bigint "estimated_driving_time_in_seconds"
    t.string "status", default: "processing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "routing_output"
    t.index ["token"], name: "index_routing_infos_on_token", unique: true
  end

end
