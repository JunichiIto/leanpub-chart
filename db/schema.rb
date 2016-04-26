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

ActiveRecord::Schema.define(version: 20160426214323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sales", force: :cascade do |t|
    t.decimal  "cause_royalty_percentage",  null: false
    t.decimal  "author_royalty_percentage", null: false
    t.decimal  "author_royalties",          null: false
    t.decimal  "cause_royalties",           null: false
    t.datetime "author_paid_out_at"
    t.datetime "cause_paid_out_at"
    t.integer  "royalty_days_hold",         null: false
    t.decimal  "publisher_royalties",       null: false
    t.datetime "publisher_paid_out_at"
    t.string   "author_username",           null: false
    t.string   "publisher_slug"
    t.string   "user_email"
    t.string   "purchase_uuid",             null: false
    t.string   "invoice_id",                null: false
    t.datetime "date_purchased",            null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "sales", ["purchase_uuid", "author_username"], name: "index_sales_on_purchase_uuid_and_author_username", unique: true, using: :btree

end
