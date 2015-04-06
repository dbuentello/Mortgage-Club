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

ActiveRecord::Schema.define(version: 20150405225554) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string  "street_address"
    t.string  "street_address2"
    t.string  "zip"
    t.text    "state"
    t.text    "city"
    t.text    "full_text"
    t.integer "property_id"
    t.integer "borrower_address_id"
    t.integer "borrower_employer_id"
  end

  create_table "borrower_addresses", force: :cascade do |t|
    t.integer "borrower_id"
    t.integer "years_at_address"
    t.boolean "is_rental"
    t.boolean "is_current",       default: false, null: false
  end

  add_index "borrower_addresses", ["borrower_id"], name: "index_borrower_addresses_on_borrower_id", using: :btree

  create_table "borrower_employers", force: :cascade do |t|
    t.integer "borrower_id"
    t.string  "employer_name"
    t.string  "employer_contact_name"
    t.string  "employer_contact_number"
    t.string  "job_title"
    t.integer "months_at_employer"
    t.integer "years_at_employer"
    t.boolean "is_current"
  end

  add_index "borrower_employers", ["borrower_id"], name: "index_borrower_employers_on_borrower_id", using: :btree

  create_table "borrower_government_monitoring_infos", force: :cascade do |t|
    t.integer "borrower_id"
    t.boolean "is_hispanic_or_latino"
    t.integer "gender_type"
  end

  add_index "borrower_government_monitoring_infos", ["borrower_id"], name: "index_borrower_government_monitoring_infos_on_borrower_id", using: :btree

  create_table "borrower_races", force: :cascade do |t|
    t.integer "borrower_government_monitoring_info_id"
    t.integer "race_type"
  end

  add_index "borrower_races", ["borrower_government_monitoring_info_id"], name: "index_borrower_races_on_borrower_government_monitoring_info_id", using: :btree

  create_table "borrowers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "suffix"
    t.datetime "dob"
    t.binary   "ssn"
    t.string   "phone"
    t.integer  "years_in_school"
    t.integer  "marital_status"
    t.integer  "dependent_ages",                            default: [], array: true
    t.decimal  "gross_income",     precision: 13, scale: 2
    t.decimal  "gross_overtime",   precision: 11, scale: 2
    t.decimal  "gross_bonus",      precision: 11, scale: 2
    t.decimal  "gross_commission", precision: 11, scale: 2
    t.integer  "loan_id"
    t.integer  "user_id"
    t.integer  "dependent_count"
  end

  add_index "borrowers", ["loan_id"], name: "index_borrowers_on_loan_id", using: :btree
  add_index "borrowers", ["user_id"], name: "index_borrowers_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "author"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "type"
    t.integer  "borrower_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "documents", ["borrower_id"], name: "index_documents_on_borrower_id", using: :btree

  create_table "loans", force: :cascade do |t|
    t.integer "purpose"
    t.integer "user_id"
  end

  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree

  create_table "properties", force: :cascade do |t|
    t.integer "property_type"
    t.integer "usage"
    t.integer "original_purchase_year"
    t.decimal "original_purchase_price",    precision: 13, scale: 2
    t.decimal "purchase_price",             precision: 13, scale: 2
    t.decimal "market_price",               precision: 13, scale: 2
    t.decimal "gross_rental_income",        precision: 11, scale: 2
    t.decimal "estimated_property_tax",     precision: 11, scale: 2
    t.decimal "estimated_hazard_insurance", precision: 11, scale: 2
    t.boolean "is_impound_account"
    t.integer "loan_id"
  end

  add_index "properties", ["loan_id"], name: "index_properties_on_loan_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
