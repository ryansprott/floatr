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

ActiveRecord::Schema.define(version: 2021_03_15_021344) do

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

  create_table "sources", force: :cascade do |t|
    t.integer "mmsi"
    t.string "ship_name"
    t.string "callsign"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
  end

  create_table "type10_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "destination_mmsi"
    t.index ["message_id"], name: "index_type10_specifics_on_message_id"
  end

  create_table "type15_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "interrogation1_mmsi"
    t.integer "interrogation1_type1"
    t.integer "interrogation1_offset1"
    t.integer "interrogation1_type2"
    t.integer "interrogation1_offset2"
    t.integer "interrogation2_mmsi"
    t.integer "interrogation2_type"
    t.integer "interrogation2_offset"
    t.index ["message_id"], name: "index_type15_specifics_on_message_id"
  end

  create_table "type18_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "true_heading"
    t.index ["message_id"], name: "index_type18_specifics_on_message_id"
  end

  create_table "type21_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "aid_type"
    t.integer "epfd_type"
    t.string "name_extension"
    t.boolean "off_position"
    t.string "ship_name"
    t.boolean "virtual_aid"
    t.index ["message_id"], name: "index_type21_specifics_on_message_id"
  end

  create_table "type24_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.string "callsign"
    t.string "ship_name"
    t.integer "ship_cargo_type"
    t.string "vendor_id"
    t.integer "model_code"
    t.integer "serial_number"
    t.integer "mothership_mmsi"
    t.index ["message_id"], name: "index_type24_specifics_on_message_id"
  end

  create_table "type27_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "navigational_status"
    t.boolean "gnss"
    t.index ["message_id"], name: "index_type27_specifics_on_message_id"
  end

  create_table "type4_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.index ["message_id"], name: "index_type4_specifics_on_message_id"
  end

  create_table "type5_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "ais_version"
    t.string "callsign"
    t.string "destination"
    t.integer "epfd_type"
    t.datetime "eta"
    t.integer "imo_number"
    t.string "ship_name"
    t.integer "ship_cargo_type"
    t.decimal "static_draught"
    t.index ["message_id"], name: "index_type5_specifics_on_message_id"
  end

  create_table "type7_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "ack1_mmsi"
    t.integer "ack2_mmsi"
    t.integer "ack3_mmsi"
    t.integer "ack4_mmsi"
    t.integer "ack1_sequence_number"
    t.integer "ack2_sequence_number"
    t.integer "ack3_sequence_number"
    t.integer "ack4_sequence_number"
    t.index ["message_id"], name: "index_type7_specifics_on_message_id"
  end

  create_table "type8_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.boolean "course_quality"
    t.decimal "dimension_beam"
    t.decimal "dimension_draught"
    t.decimal "dimension_length"
    t.string "european_vessel_id"
    t.integer "hazardous_cargo"
    t.boolean "heading_quality"
    t.integer "load_status"
    t.integer "ship_type"
    t.boolean "speed_quality"
    t.string "encrypted_data"
    t.index ["message_id"], name: "index_type8_specifics_on_message_id"
  end

  create_table "type9_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "altitude_meters"
    t.index ["message_id"], name: "index_type9_specifics_on_message_id"
  end

  create_table "type_cnb_specifics", force: :cascade do |t|
    t.bigint "message_id"
    t.integer "navigational_status"
    t.integer "true_heading"
    t.decimal "rate_of_turn"
    t.index ["message_id"], name: "index_type_cnb_specifics_on_message_id"
  end

  add_foreign_key "courses", "messages"
  add_foreign_key "dimensions", "messages"
  add_foreign_key "mysteries", "messages"
  add_foreign_key "positions", "messages"
  add_foreign_key "type10_specifics", "messages"
  add_foreign_key "type15_specifics", "messages"
  add_foreign_key "type18_specifics", "messages"
  add_foreign_key "type21_specifics", "messages"
  add_foreign_key "type24_specifics", "messages"
  add_foreign_key "type27_specifics", "messages"
  add_foreign_key "type4_specifics", "messages"
  add_foreign_key "type5_specifics", "messages"
  add_foreign_key "type7_specifics", "messages"
  add_foreign_key "type8_specifics", "messages"
  add_foreign_key "type9_specifics", "messages"
  add_foreign_key "type_cnb_specifics", "messages"
end
