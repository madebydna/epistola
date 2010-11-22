require 'mail'
require 'rest-client'
require 'json'

module MailBot
  class Bot
    
    def self.run(config, &block)
      bot = self.new(config)
      block.arity < 1 ? bot.instance_eval(&block) : block.call(bot)
      bot.poll
    end
    
    attr_accessor :list
    def initialize(config)
      @config = config
      setup_mail_defaults
    end
  
    def poll
      search_for = build_search
      Mail.find :count => 60, :what => :first, :order => :asc,
                :keys => search_for do |mail|
        build_message(mail)
      end
      # update config "last_run" attribute to use next time
      @config.update_last_run!
    end
    
    def build_search
      search_array = ["TO", @list]
      unless @config.last_run.nil?
        # net/imap also supports SINCE <date> for search args
        search_array << "SINCE"
        search_array << @config.last_run.strftime("%d-%b-%Y")
      end
      return search_array
    end
  
  
    def build_message(mail)
      mapped = @config.mapper.map(mail)
      send_message(mapped)
    end
  
    def send_message(msg)
      # using HTTP basic authentication
      private_resource = RestClient::Resource.new @config.service_url, 
                         :user => @config.api_username, :password => @config.api_password
    
      private_resource.post msg, :content_type => :json, :accept => :json
    end
    
    def setup_mail_defaults
      mail_options = { :address => "imap.gmail.com", :port => 993,  
                       :user_name => @config.email_username,
                       :password => @config.email_password,
                       :enable_ssl => true }

      Mail.defaults do
        retriever_method :imap, mail_options
      end
    end
    
  end
end

