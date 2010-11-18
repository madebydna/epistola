class AddInReplyToToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :in_reply_to, :string
  end

  def self.down
    remove_column :messages, :in_reply_to
  end
end
