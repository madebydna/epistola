class Message < ActiveRecord::Base
  belongs_to :group, :counter_cache => true
  
  has_ancestry :orphan_strategy => :rootify, :cache_depth => true
  validates_uniqueness_of :guid
    
  #scope :ordered_threads, select("subject, MAX(created_at) AS last_message_date, user, ancestry").group("id").
        #having("id IN (SELECT id FROM messages WHERE ancestry IS NULL)")
   
  before_create :set_parent_and_thread_id
  after_create :update_orphaned_children
  before_update :reset_thread_id
  
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
  
  # ...
  def thread_param
    "#{id}-#{subject.strip.downcase.gsub('&', 'and').gsub(' ', '-').gsub(/[^\w-]/,'')}"
  end

private

  def set_parent_and_thread_id
    self.parent = self.class.find_by_guid(in_reply_to)
    self.thread_id = parent.thread_id if parent
  end
  
  # this is in case reply messages get downloaded BEFORE the parent
  def update_orphaned_children
    self.class.update_all({ :ancestry => self.child_ancestry }, { :in_reply_to => self.guid })
    # thread_id can only be set here safely for new records without a parent
    # newly saved record shouldn't already have child records
    if thread_id.blank? && has_children?
      self.update_attribute(:thread_id, children.first.thread_id)
    elsif thread_id.blank?
      highest_thread_id = self.class.maximum('thread_id')
      self.update_attribute(:thread_id, highest_thread_id ? (highest_thread_id + 1) : 1)
    end
  end
  
  def reset_thread_id
    # if ancestry was updated, make sure the thread_id is that of the parent
    # this can happen if parent gets downloaded later
    if !ancestry_was.blank? && thread_id != parent.thread_id
      self.thread_id = parent.thread_id
    end
  end
  
end
