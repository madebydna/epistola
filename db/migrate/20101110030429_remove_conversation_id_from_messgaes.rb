class RemoveConversationIdFromMessgaes < ActiveRecord::Migration
  def self.up
    remove_column :messages, :conversation_id
  end

  def self.down
    add_column :messages, :conversation_id, :integer
  end
end
