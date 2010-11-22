require "#{Rails.root}/lib/mail_bot"
require "yaml"

namespace :mail_bot do 
  
  desc "Downloads mail for a given mailing list"
  task :download_messages => :environment do
    config = MailBot::Configuration.load
    MailBot::Bot.run(config) do
      @list = "ruby-mendicant-university"
    end
    puts "Messages downloaded. Now arranging into tree ..."
    Message.arrange_into_tree
  end
  
end