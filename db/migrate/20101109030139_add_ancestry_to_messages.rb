class AddAncestryToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :ancestry, :string
    add_column :messages, :ancestry_depth, :integer
  end

  def self.down
    remove_column :messages, :ancestry_depth
    remove_column :messages, :ancestry
  end
end
