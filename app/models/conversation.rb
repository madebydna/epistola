class Conversation < ActiveRecord::Base
  has_many :messages
  belongs_to :group, :counter_cache => true
  
  def last_message_date
    last_message.created_at
  end
  
  def last_message_user
    last_message.user
  end
  
  def last_message
    @last_message ||= messages.order("created_at DESC").first
  end
  
end
