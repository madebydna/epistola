class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "messages_count"
    end
  end

  def self.down
    drop_table :groups
  end
end
