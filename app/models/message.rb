class Message < ActiveRecord::Base
  belongs_to :conversation, :counter_cache => true
  
  def self.search(search, page)
    # select "sample" messages that only have the search term in the subject of the conversation
    # this is to avoid loading of all messages that belong to a conversations that has the search term in the subject
    in_subject_only = select("messages.id").joins(:conversation).
                      where("conversations.subject LIKE :search AND messages.body NOT LIKE :search", 
                            {:search => "%#{search[:q]}%"}).
                      group("messages.conversation_id").map(&:id)
    
    sql_conditions = "(body LIKE :search OR messages.id IN (:subject_only))"
    sql_values = {:search => "%#{search[:q]}%", :subject_only => in_subject_only}
    if search[:group_id]
      sql_conditions += " AND conversations.group_id = :group_id" 
      sql_values.store :group_id, search[:group_id]
    end
    
    paginate :per_page => 20, :page => page,
             :select => "messages.*, conversations.subject AS subject",  
             :conditions => [sql_conditions, sql_values], 
             :joins => [:conversation => :group],
             :order => 'messages.created_at DESC'
  end
end
