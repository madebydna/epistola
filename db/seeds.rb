require 'populator'
require 'ffaker'

topics = ["Focus Group: Design", "Focus Group: Concurrency", "RubyConf 2010", "Introduce Yourselves!", 
          "Questions about RMU?", "Alumni List", "Course Registration is now open", "University Web",
          "IRC Channel", "Method Hooks", "Office Hours and Interviews", "Exercises released", "Our new logo"]
          
names = []
1.upto(10) do |i|
  names << Faker::Name.name
end

["RMU General", "RMU Alumni", "RMU Session 3"].each do |name|
  Group.find_or_create_by_name(:name => name)
end

@groups = Group.all

while topics.length > 0 do 
  subject = topics.pop
  # hack to set counter_cache in @conversation, since Populator gem skips callbacks
  num_messages = rand(30)
  @conversation = Conversation.create(:subject => subject, 
                      :group => @groups[rand(@groups.length)],
                      :messages_count => num_messages, 
                      :created_at => rand(4).weeks.ago)
  Message.populate(num_messages) do |message|
    message.conversation_id = @conversation
    message.user = names[rand(names.length)]
    message.body = Faker::Lorem.paragraphs(rand(4) + 1).join("\n\n")
    message.created_at = @conversation.created_at + rand(7).days
  end
end


