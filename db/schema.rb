# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_05_204109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.bigint "message_id"
    t.decimal "course_over_ground"
    t.decimal "speed_over_ground"
    t.index ["message_id"], name: "index_courses_on_message_id"
  end

  create_table "dimensions", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "ship_dimension_to_bow"
    t.integer "ship_dimension_to_port"
    t.integer "ship_dimension_to_starboard"
    t.integer "ship_dimension_to_stern"
    t.index ["message_id"], name: "index_dimensions_on_message_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "message_type"
    t.integer "repeat_indicator"
    t.integer "source_mmsi"
    t.string "category_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mysteries", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "designated_area_code"
    t.integer "functional_id"
    t.text "full_dearmored_ais_payload"
    t.index ["message_id"], name: "index_mysteries_on_message_id"
  end

  create_table "positions", force: :cascade do |t|
    t.bigint "message_id"
    t.string "latitude"
    t.string "longitude"
    t.index ["message_id"], name: "index_positions_on_message_id"
  end

  add_foreign_key "courses", "messages"
  add_foreign_key "dimensions", "messages"
  add_foreign_key "mysteries", "messages"
  add_foreign_key "positions", "messages"
end
