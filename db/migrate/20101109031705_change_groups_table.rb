class ChangeGroupsTable < ActiveRecord::Migration
  def self.up
    remove_column :groups, :conversations_count
    add_column :groups, :messages_count, :integer
  end

  def self.down
    add_column :groups, :conversations_count, :integer
    remove_column :groups, :messages_count
  end
end
