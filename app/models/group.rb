class Group < ActiveRecord::Base
  has_many :messages
  
  def conversations_count
    Message.conversations_count_in_group(self.id).
    all.first.count.to_i
  end
  
end
