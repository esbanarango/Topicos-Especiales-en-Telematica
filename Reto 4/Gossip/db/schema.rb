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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120521195759) do

  create_table "messages", :force => true do |t|
    t.string   "content",    :limit => 160, :null => false
    t.integer  "user_id",                   :null => false
    t.integer  "room_id",                   :null => false
    t.integer  "to"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "rooms", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "rooms_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",        :limit => 25,                    :null => false
    t.string   "password_digest",                                  :null => false
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.boolean  "admin",                         :default => false
    t.string   "device",                        :default => "web"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
