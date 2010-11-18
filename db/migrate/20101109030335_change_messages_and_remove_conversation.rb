class ChangeMessagesAndRemoveConversation < ActiveRecord::Migration
  def self.up
    drop_table :conversations
    add_column :messages, :guid, :string
    add_column :messages, :subject, :string
    add_column :messages, :group_id, :integer
  end

  def self.down
    remove_column :messages, :guid
    remove_column :messages, :subject
    remove_column :messages, :group_id
    
    create_table :conversations do |t|
      t.integer :group_id
      t.string :subject
      t.integer :messages_count, :default => 0
      t.timestamps
    end
  end
end
