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

ActiveRecord::Schema.define(version: 20161210201737) do

# Could not dump table "bookpages" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "bookprices", force: :cascade do |t|
    t.string   "format"
    t.string   "status",        default: "АКТИВЕН"
    t.string   "default",       default: "НЕТ"
    t.integer  "minpagescount", default: 20
    t.integer  "maxpagescount", default: 30
    t.integer  "coverprice",    default: 0
    t.integer  "twopageprice",  default: 0
    t.integer  "coverwidth",    default: 0
    t.integer  "coverheight",   default: 0
    t.integer  "twopagewidth",  default: 0
    t.integer  "twopageheight", default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "books", force: :cascade do |t|
    t.integer  "price",        default: 0
    t.string   "name",         default: "My photobook"
    t.string   "fontfamily",   default: "PT Sans"
    t.string   "fontcolor",    default: "black"
    t.string   "fontsize",     default: "6"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "user_id"
    t.integer  "bookprice_id"
  end

  add_index "books", ["bookprice_id"], name: "index_books_on_bookprice_id"
  add_index "books", ["user_id"], name: "index_books_on_user_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "deliveries", force: :cascade do |t|
    t.string   "name"
    t.integer  "price",      default: 0
    t.string   "default",    default: "НЕТ"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "discounts", force: :cascade do |t|
    t.string   "name"
    t.integer  "value",      default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.integer  "bookscount"
    t.string   "fio"
    t.string   "phone"
    t.integer  "zipcode"
    t.string   "city"
    t.string   "address"
    t.string   "email"
    t.string   "comment"
    t.integer  "price",       default: 0
    t.string   "status",      default: "Создан"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "book_id"
    t.integer  "delivery_id"
  end

  add_index "orders", ["book_id"], name: "index_orders_on_book_id"
  add_index "orders", ["delivery_id"], name: "index_orders_on_delivery_id"

# Could not dump table "phgalleries" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "socialicons", force: :cascade do |t|
    t.string   "name"
    t.string   "iconlink"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
