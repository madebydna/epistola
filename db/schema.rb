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

ActiveRecord::Schema.define(:version => 20101115053246) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messages_count"
  end

  create_table "messages", :force => true do |t|
    t.string   "user"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.string   "guid"
    t.string   "subject"
    t.integer  "group_id"
    t.string   "in_reply_to"
    t.integer  "thread_id"
  end

  create_table "products", :id => false, :force => true do |t|
    t.integer "item"
    t.integer "supplier"
    t.decimal "price",    :precision => 6, :scale => 2
  end

  create_table "test", :force => true do |t|
    t.string   "ancestry",   :null => false
    t.datetime "created_at", :null => false
    t.string   "subject",    :null => false
    t.integer  "thread_id",  :null => false
  end

  create_table "threads", :force => true do |t|
    t.string "thread", :null => false
  end

end
