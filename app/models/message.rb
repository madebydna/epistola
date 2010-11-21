class Message < ActiveRecord::Base
  belongs_to :group, :counter_cache => true
  
  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
  validates_uniqueness_of :guid
  validates :group_id, :guid, :user, :presence => true
  
  before_create :set_parent_and_thread_id
  after_create :update_orphaned_children
  
  # groupwise aggregate to get last post and message count per thread
  scope :threads, select("messages.*, count(*) AS total").
                  joins("JOIN messages AS m2 ON messages.thread_id = m2.thread_id").
                  group("messages.thread_id, messages.id").
                  having("messages.created_at = MAX(m2.created_at)")
  
  def last_message_in_thread
    if is_root? and is_childless?
      self
    elsif is_root? and has_children?
      descendants.last
    else
      root.descendants.last
    end
  end
  
  # gets a nested (ordered) hash that represents a message thread
  def get_thread
    is_root? ? subtree.arrange : root.subtree.arrange
  end
  
  # refers to number of authors in a thread
  def authors_count
    authors.keys.length
  end
  
  # groups a thread by authors
  def authors
    subtree.group_by {|m| m.user}    
  end
  
  def author
    # gets rid of email address in name
    user.gsub(/\s*<[\w+\-.]+@[a-z\d\-.]+\.[a-z]+>/i, '')
  end
  
  def thread_param
    "#{id}-#{subject.strip.downcase.gsub('&', 'and').gsub(' ', '-').gsub(/[^\w-]/,'')}"
  end
  
  def self.random_guid
    chars = (('a'..'z').to_a + ('0'..'9').to_a)
    (1..8).map { |a| chars[rand(chars.size)] }.join
  end

private

  def set_parent_and_thread_id
    self.parent = self.class.find_by_guid(in_reply_to)
    self.thread_id = parent.thread_id if parent
  end
  
  # this is in case reply messages get downloaded BEFORE the parent
  def update_orphaned_children
    # update_all skips the update_descendants_with_new_ancestry callback, so have to do this the long way
    self.class.where(:in_reply_to => self.guid).all.each do |child|
      child.ancestry = child_ancestry_of_new_record
      child.save
    end
    reset_thread_id
  end
  
  def reset_thread_id
    if thread_id.blank? && descendants_of_new_record.any? # no ancestors, but descendants
      self.update_attribute(:thread_id, descendants_of_new_record.first.thread_id)
    elsif !thread_id.blank? && descendants_of_new_record.any? # ancestors and descendants
     self.class.update_all({:thread_id => thread_id}, descendants_of_new_record_conditions)
    elsif thread_id.blank? # no ancestors or descendants
      highest_thread_id = self.class.maximum('thread_id')
      self.update_attribute(:thread_id, highest_thread_id ? (highest_thread_id + 1) : 1)
    end
  end
  
  def child_ancestry_of_new_record
    ancestry.blank? ? self.id : "#{self.ancestry}/#{self.id}"
  end
  
  # ancestry gem uses dirty attributes as the basis to determine child_ancestry
  # this will not work for newly created records, since ancestry_was will always be nil
  def descendants_of_new_record
    self.class.where(descendants_of_new_record_conditions)
  end
  
  def descendants_of_new_record_conditions
    ["ancestry like ? or ancestry = ?", "#{child_ancestry_of_new_record}/%", child_ancestry_of_new_record]
  end
  
end
