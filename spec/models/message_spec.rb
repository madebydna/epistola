require 'spec_helper'

describe Message do
  describe "saving a single message" do   
    it "should require a group_id" do
      without_group = lambda {
        Message.create(Factory.attributes_for(:message).merge!(:group_id => nil))
      }
      without_group.should_not change(Group, :count)
    end
    
    it "should not save messages with duplicate guid" do
      @message = Factory(:message)
      second_msg = Message.new Factory.attributes_for(:message).merge!(:guid => @message.guid)
      second_msg.should_not be_valid
      second_msg.should have(1).error_on(:guid)
    end
    
    it "should not have a parent" do
      @message = Factory(:message)
      @message.parent.should be_nil
      @message.ancestry.should be_nil
    end
    
    it "should have a thread_id set to 1" do
      @message = Factory(:message)
      @message.thread_id.should == 1
    end
  end
  

  describe "saving a message as a reply to another message" do
    
    before(:each) do
      @parent_msg = Factory(:message)
      reply_attrs = Factory.attributes_for(:message).merge!(:in_reply_to => @parent_msg.guid)
      @reply_msg = @parent_msg.group.messages.create(reply_attrs)
    end
    
    it "should have a parent" do
      @reply_msg.parent.should == @parent_msg
    end
    
    it "should have the same thread id as the parent" do
      @reply_msg.thread_id.should == @parent_msg.thread_id
    end
    
  end
  
  describe "saving a second message that is not a reply to the first" do
    before(:each) do
      @first_msg = Factory(:message)
      @second_msg = @first_msg.group.messages.create(Factory.attributes_for(:message))
    end
    
    it "should not have a parent" do
      @second_msg.parent.should be_nil
    end
    
    it "should have a different thread_id from the first message" do
      @second_msg.thread_id.should_not == @first_msg.thread_id
      @second_msg.thread_id.should == @first_msg.thread_id + 1
    end
    
  end
  
  describe "saving a reply message BEFORE the parent was saved" do
    
    before(:all) do
      @in_reply_to = Message.random_guid
      @group = Factory(:group)
      @reply = @group.messages.create(Factory.attributes_for(:message).
                                      merge!(:in_reply_to => @in_reply_to,
                                      :body => "Reply"))
    end
    
    it "should not have a parent" do
      @reply.parent.should be_nil
    end
    
    it "should have an independent thread_id" do
      @reply.thread_id.should == 1
    end
    
    describe "when parent gets saved later" do
      
      before(:all) do
        @parent = @group.messages.create(Factory.attributes_for(:message).
                  merge!(:guid => @in_reply_to, :body => "Parent"))
      end
      
      it "should get updated with parent ancestry" do
        @reply.reload.parent.should == @parent
      end
      
      it "should inherit thread_id of child" do
        @parent.thread_id.should == @reply.thread_id
      end
      
    end
        
  end
  
  describe "saving grandparent, then grandchild, then parent" do
    before(:each) do
      @grandparent_guid = Message.random_guid
      @group = Factory(:group)
      @parent_guid = Message.random_guid
      @grandparent = @group.messages.create(Factory.attributes_for(:message).
                     merge!(:guid => @grandparent_guid, :body => "Grandparent"))
      @grandchild = @group.messages.create(Factory.attributes_for(:message).
                    merge!(:in_reply_to => @parent_guid, :body => "Grandchild"))                               
    end
    
    it "should save grandchild as part of an independent thread" do
      @grandchild.thread_id.should_not == @grandparent.thread_id
    end
    
    it "should save grandchild without parent" do
      @grandchild.parent.should be_nil
    end
    
    describe "when parent gets saved" do
      
      before(:each) do
        @parent = @group.messages.create(Factory.attributes_for(:message).
                  merge!(:guid => @parent_guid, :in_reply_to => @grandparent_guid, 
                  :body => "Parent"))
      end
      
      it "should correctly assign relationships" do
        @parent.parent.should == @grandparent   
        @grandchild.reload.parent.should == @parent          
      end

      it "should correctly assign thread_id of grandparent to both parent and grandchild" do
        @parent.thread_id.should == @grandparent.thread_id
        @grandchild.reload.thread_id.should == @grandparent.thread_id
      end
      
    end
    
    describe "when parent gets saved and children have other descendants" do
      it "should correctly assign thread_id to all descendants" do
        @greatgrandchild = @group.messages.create(Factory.attributes_for(:message).
                           merge!(:in_reply_to => @grandchild.guid, :body => "Greatgrandchild"))
        @parent = @group.messages.create(Factory.attributes_for(:message).
                  merge!(:guid => @parent_guid, :in_reply_to => @grandparent_guid, :body => "Parent"))    
        @greatgrandchild.reload.thread_id.should == @grandparent.thread_id
      end
    end
    
  end
  
  
  
end
