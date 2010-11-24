class Message < ActiveRecord::Base
  belongs_to :group, :counter_cache => true
  
  has_ancestry :orphan_strategy => :rootify
  validates_uniqueness_of :guid
  validates :group_id, :guid, :user, :presence => true
  
  # groupwise aggregate to get last post and message count per thread
  scope :threads, select("messages.id, messages.user, messages.subject, messages.created_at, 
  count(messages.thread_id) AS total").
                  joins("JOIN messages AS m2 ON messages.thread_id = m2.thread_id").
                  group("messages.thread_id, messages.id, messages.user, messages.subject, messages.created_at").
                  having("messages.created_at = MAX(m2.created_at)")
  scope :thread_starters, where("(in_reply_to = '' OR in_reply_to IS NULL) AND ancestry IS NULL")
  
  scope :conversations_count_in_group, lambda {|group_id| select("count(*)").joins("INNER JOIN (SELECT DISTINCT ON (thread_id) id FROM messages 
  WHERE messages.group_id = #{group_id} GROUP BY thread_id, id) AS m2 ON m2.id = messages.id")}
  
  # full text search with Postgres and texticle
  index do
    subject
    body
  end
  
  
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
  
  def thread_title
    self.subject.gsub(/^[Re:\s]*/, '')
  end
  
  def author
    # gets rid of email address in name
    user.gsub(/\s*<[\w+\-.]+@[a-z\d\-.]+\.[a-z]+>/i, '')
  end
  
  def thread_param
    "#{id}-#{subject.strip.downcase.gsub('&', 'and').gsub(' ', '-').gsub(/[^\w-]/,'')}"
  end
  
  # full text search on subject and body, within a particular group or not
  def self.do_search(params, page)
    within_group = params[:group_id]
    if within_group
      search(params[:q]).where(:group_id => within_group).paginate(:page => page)
    else
      search(params[:q]).paginate(:page => page)
    end
  end
  
  # for tests - should probably be moved into a test helper
  def self.random_guid
    chars = (('a'..'z').to_a + ('0'..'9').to_a)
    (1..8).map { |a| chars[rand(chars.size)] }.join
  end
  
  # arrange newly downloaded messages into their inherent tree structure
  def self.arrange_into_tree
    if first_time?
      arrange_for_first_time
    else
      integrate_new_messages
    end
  end
  
  def self.arrange_for_first_time
    thread_starters.all.each do |msg|
      msg.update_attribute(:thread_id, next_thread_id) unless msg.thread_id
      msg.find_unassigned_children
    end
  end
  
  def self.integrate_new_messages
    where(:thread_id => nil).order("created_at asc").all.each do |msg|
      if msg.in_reply_to.blank?
        msg.update_attribute(:thread_id, next_thread_id)
      else
        p = where(:guid => msg.in_reply_to).first
        msg.assign_parent(p) if p
      end
    end
  end
  
  def find_unassigned_children
    if unassigned_children.any?
      unassigned_children.each do |child|
        child.assign_parent(self)
        child.find_unassigned_children
      end
    end
  end
  
  def assign_parent(some_parent)
    self.parent = some_parent
    self.thread_id = some_parent.thread_id
    self.save
  end
  
  def unassigned_children
    self.class.where(:in_reply_to => self.guid, :ancestry => nil).all
  end
  
  def self.next_thread_id
    highest_thread_id = maximum('thread_id')
    highest_thread_id ? (highest_thread_id + 1) : 1
  end
  
  def self.first_time?
    maximum('thread_id').nil?
  end
    
end
