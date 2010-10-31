require "spec_helper"

describe ConversationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/conversations" }.should route_to(:controller => "conversations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/conversations/new" }.should route_to(:controller => "conversations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/conversations/1" }.should route_to(:controller => "conversations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/conversations/1/edit" }.should route_to(:controller => "conversations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/conversations" }.should route_to(:controller => "conversations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/conversations/1" }.should route_to(:controller => "conversations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/conversations/1" }.should route_to(:controller => "conversations", :action => "destroy", :id => "1")
    end

  end
end
