class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table "messages" do |t|
      t.string   "user"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "ancestry"
      t.string   "guid"
      t.string   "subject"
      t.integer  "group_id"
      t.string   "in_reply_to"
      t.integer  "thread_id"
    end
  end

  def self.down
    drop_table :messages
  end
end
