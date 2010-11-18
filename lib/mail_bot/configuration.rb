require 'mail_bot'
require "#{Rails.root}/lib/mail_bot/header_mapper"
require 'ostruct'
require 'yaml'

module MailBot
  
  class Configuration < OpenStruct
    
    DEFAULT_PATH = "#{Rails.root}/config/mail.yml"
    DEFAULT_MAPPER = MailBot::HeaderMapper
    
    def self.load
      config = YAML.load(File.read(DEFAULT_PATH))[Rails.env]
      self.new(config)
    end
    
    def mapper
      if @table[:mapper].nil?
        DEFAULT_MAPPER.new
      else
        @table[:mapper].new
      end
    end
    
    def update_last_run!
      @table[:last_run] = Time.now
      File.open(DEFAULT_PATH, 'w') do |file|
        file.write({Rails.env => self.marshal_dump}.to_yaml)
      end
    end
    
  end
  
end