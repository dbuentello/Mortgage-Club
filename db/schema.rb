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

ActiveRecord::Schema.define(version: 20150316042204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string  "street_address"
    t.string  "secondary_street_address"
    t.string  "zipcode"
    t.integer "state"
  end

  create_table "borrower_addresses", force: :cascade do |t|
    t.integer "borrower_id"
    t.integer "address_id"
    t.integer "years_at_address"
    t.boolean "is_rental"
    t.boolean "is_current"
  end

  add_index "borrower_addresses", ["address_id"], name: "index_borrower_addresses_on_address_id", using: :btree
  add_index "borrower_addresses", ["borrower_id"], name: "index_borrower_addresses_on_borrower_id", using: :btree

  create_table "borrower_employers", force: :cascade do |t|
    t.integer "borrower_id"
    t.string  "employer_name"
    t.integer "employer_address_id"
    t.string  "employment_contact_name"
    t.string  "employment_contact_number"
    t.string  "job_title"
    t.integer "months_at_employment"
    t.integer "years_at_employment"
    t.boolean "is_current"
  end

  add_index "borrower_employers", ["borrower_id"], name: "index_borrower_employers_on_borrower_id", using: :btree
  add_index "borrower_employers", ["employer_address_id"], name: "index_borrower_employers_on_employer_address_id", using: :btree

  create_table "borrower_government_monitoring_info", force: :cascade do |t|
    t.integer "borrower_id"
    t.boolean "hispanic_or_latino"
    t.integer "gender_type"
  end

  add_index "borrower_government_monitoring_info", ["borrower_id"], name: "index_borrower_government_monitoring_info_on_borrower_id", using: :btree

  create_table "borrower_race", force: :cascade do |t|
    t.integer "borrower_government_monitoring_info_id"
    t.integer "race_type"
  end

  add_index "borrower_race", ["borrower_government_monitoring_info_id"], name: "index_borrower_race_on_borrower_government_monitoring_info_id", using: :btree

  create_table "borrowers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "suffix"
    t.datetime "date_of_birth"
    t.binary   "social_security_number"
    t.string   "phone_number"
    t.integer  "years_in_school"
    t.integer  "marital_status_type"
    t.integer  "ages_of_dependents",                              default: [], array: true
    t.decimal  "gross_income",           precision: 13, scale: 2
    t.decimal  "gross_overtime",         precision: 11, scale: 2
    t.decimal  "gross_bonus",            precision: 11, scale: 2
    t.decimal  "gross_commission",       precision: 11, scale: 2
  end

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.integer "purpose_type"
    t.integer "property_id"
    t.integer "borrower_id"
    t.integer "second_borrower_id"
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "address_id"
    t.integer  "property_type"
    t.integer  "usage_type"
    t.datetime "original_purchase_date"
    t.decimal  "original_purchase_price",    precision: 13, scale: 2
    t.decimal  "purchase_price",             precision: 13, scale: 2
    t.decimal  "market_price",               precision: 13, scale: 2
    t.decimal  "gross_rental_income",        precision: 11, scale: 2
    t.decimal  "estimated_property_tax",     precision: 11, scale: 2
    t.decimal  "estimated_hazard_insurance", precision: 11, scale: 2
    t.boolean  "impound_account"
  end

  add_index "properties", ["address_id"], name: "index_properties_on_address_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
