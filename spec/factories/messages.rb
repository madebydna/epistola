# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :message do |f|
  f.conversation_id 1
  f.user "MyString"
  f.body "MyText"
end
