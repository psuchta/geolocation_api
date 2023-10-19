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

ActiveRecord::Schema[7.0].define(version: 2023_10_19_141836) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ip_infos", force: :cascade do |t|
    t.string "ip"
    t.string "url"
    t.integer "type"
    t.string "continent_name"
    t.string "country_name"
    t.string "region_name"
    t.string "city"
    t.string "zip"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip"], name: "index_ip_infos_on_ip"
    t.index ["url"], name: "index_ip_infos_on_url"
  end

end
