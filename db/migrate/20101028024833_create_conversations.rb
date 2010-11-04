class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
      t.integer :group_id
      t.string :subject
      t.integer :messages_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :conversations
  end
end
