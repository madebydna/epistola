# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :message do |f|
  f.association :group, :factory => :group
  f.user "A. User"
  f.body "some message"
  f.subject "topic"
  f.guid { Message.random_guid }
  f.in_reply_to ""
end
