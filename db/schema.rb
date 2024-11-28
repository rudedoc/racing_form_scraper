# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_27_160013) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "horses", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.date "foaled"
    t.string "sex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jockeys", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.string "name"
    t.string "country_name"
    t.string "going"
    t.string "weather"
    t.string "surface_summary"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.string "age"
    t.string "race_class"
    t.string "distance"
    t.string "date"
    t.string "time"
    t.string "off_time"
    t.string "winning_time"
    t.integer "ride_count"
    t.string "going"
    t.boolean "has_handicap"
    t.bigint "meeting_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_races_on_meeting_id"
  end

  create_table "rides", force: :cascade do |t|
    t.integer "finish_position"
    t.string "ride_status"
    t.string "handicap"
    t.text "headgear", default: [], array: true
    t.integer "official_rating"
    t.float "jockey_claim"
    t.text "ride_description"
    t.text "commentary"
    t.string "betting", default: [], array: true
    t.bigint "horse_id", null: false
    t.bigint "jockey_id", null: false
    t.bigint "trainer_id", null: false
    t.bigint "owner_id", null: false
    t.bigint "race_id", null: false
    t.string "casualty"
    t.string "insights", default: [], array: true
    t.integer "horse_lifetime_stats_run_count"
    t.integer "horse_lifetime_stats_win_count"
    t.integer "horse_lifetime_stats_place_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["horse_id"], name: "index_rides_on_horse_id"
    t.index ["jockey_id"], name: "index_rides_on_jockey_id"
    t.index ["owner_id"], name: "index_rides_on_owner_id"
    t.index ["race_id"], name: "index_rides_on_race_id"
    t.index ["trainer_id"], name: "index_rides_on_trainer_id"
  end

  create_table "trainers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "races", "meetings"
  add_foreign_key "rides", "horses"
  add_foreign_key "rides", "jockeys"
  add_foreign_key "rides", "owners"
  add_foreign_key "rides", "races"
  add_foreign_key "rides", "trainers"
end
