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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110318124312) do

  create_table "commitments", :force => true do |t|
    t.integer  "orderable_id"
    t.integer  "user_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markets", :force => true do |t|
    t.string   "name"
    t.text     "description",          :limit => 255
    t.string   "contact_email"
    t.string   "logo_url"
    t.integer  "start_day_of_week"
    t.integer  "ordering_period"
    t.integer  "due_date_day_of_week"
    t.integer  "due_date_hour"
    t.integer  "due_date_period"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "delivery_info"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone"
  end

  create_table "order_listings", :force => true do |t|
    t.integer  "order_list_id"
    t.integer  "quantity"
    t.integer  "product_family_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_lists", :force => true do |t|
    t.integer  "user_id"
    t.datetime "order_start"
    t.datetime "order_end"
    t.datetime "delivery_start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivery_end"
  end

  create_table "orderables", :force => true do |t|
    t.integer  "product_id"
    t.decimal  "organic_price"
    t.decimal  "conventional_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_listing_id"
  end

  create_table "product_families", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description",       :limit => 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_family_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.boolean  "organic",            :default => false
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
