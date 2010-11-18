require 'spec_helper'
require "#{Rails.root}/lib/mail_bot"
require 'yaml'

describe MailBot::Configuration do
  
  before(:each) do
    @valid_config = { :email_username => 'info@madebydna.com', :email_password => 'secret',
     :api_username => 'andrea', :api_password => 'secret', :service_url => 'http://localhost:3000/messages.json',
     :last_run => nil }
  end
  
  it "should load a configuration file following the DEFAULT_PATH" do
    lambda { 
      MailBot::Configuration.load 
    }.should_not raise_error
  end
  
  describe "with valid configuration" do
    
    before(:each) do
      @default_config = MailBot::Configuration.new(@valid_config)
    end
    
    it "should create an instance with OpenStruct behavior" do
      @default_config.email_username.should == 'info@madebydna.com'
      @default_config.last_run.should be_nil
    end

    it "should have a default Mapper" do
      @default_config.mapper.should be_instance_of(MailBot::HeaderMapper)
    end
    
    it "should have an alternate Mapper if set in the configuration" do
      mock_mapper = mock('MailBot::LibrelistMapper')
      mock_mapper.should_receive(:new).and_return(mock_mapper)
      @valid_config.merge!("mapper" => mock_mapper)
      @config = MailBot::Configuration.new(@valid_config)
      @config.mapper.should_not be_instance_of(MailBot::HeaderMapper)
    end
  end
  
  describe "when when updating last_run attribute" do
    before(:each) do
      @default_config = MailBot::Configuration.new(@valid_config)
    end
    
    it "should update the file found at DEFAULT_PATH with a Time entry for :last_run" do
      mock_file = mock(File)
      File.should_receive(:open).
      with("#{Rails.root}/config/mail.yml", 'w').
      and_yield(mock_file)
      
      mock_file.should_receive(:write).with do |yaml|
        expected_yaml = YAML.load(yaml)
        expected_yaml[Rails.env][:last_run].should be_kind_of(Time)
      end
      @default_config.update_last_run!
    end
    
  end
  
end