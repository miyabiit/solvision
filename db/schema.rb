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

ActiveRecord::Schema.define(version: 2018_09_04_133256) do

  create_table "daily_solars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "facility_id", null: false
    t.date "date", null: false
    t.decimal "kwh", precision: 16, scale: 4
    t.decimal "solar_radiation", precision: 16, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_daily_solars_on_facility_id"
  end

  create_table "facilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "geocode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sales_type", default: 0, null: false
    t.integer "unit_price", default: 0, null: false
  end

  create_table "facility_aliases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "facility_id", null: false
    t.string "solar_facility_id"
    t.string "solar_facility_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_facility_aliases_on_facility_id"
    t.index ["solar_facility_id"], name: "index_facility_aliases_on_solar_facility_id", unique: true
  end

  create_table "facility_capacities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "facility_id"
    t.integer "value"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_count", default: 0, null: false
    t.index ["facility_id"], name: "index_facility_capacities_on_facility_id"
  end

  create_table "facility_projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "facility_id", null: false
    t.string "shabot_project_name"
    t.string "shabot_project_category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_facility_projects_on_facility_id"
  end

  create_table "monthly_receipts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "facility_id", null: false
    t.string "year_month", null: false
    t.bigint "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_monthly_receipts_on_facility_id"
  end

  create_table "monthly_solars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "facility_id", null: false
    t.string "month", null: false
    t.decimal "kwh", precision: 16, scale: 4
    t.decimal "solar_radiation", precision: 16, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "prev_month_rate"
    t.float "prev_year_rate"
    t.decimal "estimate_remains_kwh", precision: 16, scale: 4
    t.decimal "estimate_kwh", precision: 16, scale: 4
    t.float "neighbor_solar_radiation"
    t.float "prev_year_neighbor_solar_radiation"
    t.float "kwh_per_day"
    t.float "kwh_per_day_per_unit"
    t.decimal "mixed_kwh", precision: 16, scale: 4
    t.index ["facility_id"], name: "index_monthly_solars_on_facility_id"
  end

  create_table "receipts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "monthly_receipt_id", null: false
    t.bigint "amount", default: 0, null: false
    t.date "receipt_date"
    t.string "receipt_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["monthly_receipt_id"], name: "index_receipts_on_monthly_receipt_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "daily_solars", "facilities"
  add_foreign_key "facility_aliases", "facilities"
  add_foreign_key "facility_capacities", "facilities"
  add_foreign_key "facility_projects", "facilities"
  add_foreign_key "monthly_receipts", "facilities"
  add_foreign_key "monthly_solars", "facilities"
  add_foreign_key "receipts", "monthly_receipts"
end
