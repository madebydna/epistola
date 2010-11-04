class Group < ActiveRecord::Base
  has_many :conversations
  
  def members_count
    34
  end
  
  def recent(number_of_messages=2)
    conversations.joins(:messages).order("messages.created_at DESC").limit(number_of_messages).reverse
  end
  
end
