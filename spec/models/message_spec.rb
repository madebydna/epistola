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
    
    it "should not have a thread_id" do
      @message = Factory(:message)
      @message.thread_id.should be_nil
    end
  end
  
  describe "when arranging into a tree" do
    
    describe "saving two messages, one a reply to the other" do
      before(:each) do
        @parent_msg = Factory(:message)
        reply_attrs = Factory.attributes_for(:message).merge!(:in_reply_to => @parent_msg.guid)
        @reply_msg = @parent_msg.group.messages.create(reply_attrs)
        Message.arrange_into_tree
      end
      
      it "should have correct parent-child relationship" do
        @reply_msg.reload.parent.should == @parent_msg
      end

      it "should share the same thread id" do
        @reply_msg.reload.thread_id.should == @parent_msg.reload.thread_id
      end
    end
    
    describe "saving two unrelated messages" do
      before(:each) do
        @first_msg = Factory(:message)
        @second_msg = @first_msg.group.messages.create(Factory.attributes_for(:message))
        Message.arrange_into_tree
      end
      
      
      it "should have no relationship" do
        @second_msg.reload.parent.should be_nil
        @first_msg.reload.children.should be_empty
      end

      it "should have a different thread_ids" do
        @second_msg.reload.thread_id.should_not == @first_msg.reload.thread_id
        @second_msg.reload.thread_id.should == @first_msg.reload.thread_id + 1
      end
    end
  end
  
  describe "saving a complex tree of messages" do
    before(:all) do
      @group = Factory(:group)
      @parent_1 = @group.messages.create(Factory.attributes_for(:message))
      @parent_2 = @group.messages.create(Factory.attributes_for(:message))
      @parent_1_child_1 = @group.messages.create(Factory.attributes_for(:message).
                          merge!(:in_reply_to => @parent_1.guid))
      @parent_1_child_2 = @group.messages.create(Factory.attributes_for(:message).
                          merge!(:in_reply_to => @parent_1.guid))
      @parent_1_child_1_child_1 = @group.messages.create(Factory.attributes_for(:message).
                                 merge!(:in_reply_to => @parent_1_child_1.guid))
      Message.arrange_into_tree
    end
    
    it "should have the right number of root nodes" do
      Message.roots.length.should == 2
    end
    
    it "should have as many different thread_ids as root nodes" do
      unique_thread_ids = Message.all.map {|m| m.thread_id}.uniq 
      unique_thread_ids.length.should == Message.roots.length
    end
    
    it "should assign the right relationships" do
      @parent_1.reload.child_ids.should == [@parent_1_child_1.id, @parent_1_child_2.id]
      @parent_1_child_1_child_1.reload.parent.should == @parent_1_child_1.reload
    end
    
    describe "saving second batch of messages" do
      before(:all) do
        @parent_3 = @group.messages.create(Factory.attributes_for(:message))
        @parent_2_child_1 = @group.messages.create(Factory.attributes_for(:message).
                            merge!(:in_reply_to => @parent_2.guid))
        @parent_1_child_2_child_1 = @group.messages.create(Factory.attributes_for(:message).
                                    merge!(:in_reply_to => @parent_1_child_2.guid))
        Message.arrange_into_tree                           
      end
      
      it "should assign the right relationships" do
        @parent_3.reload.parent.should be_nil
        @parent_2_child_1.reload.parent.should == @parent_2.reload
        @parent_1_child_2_child_1.reload.parent.should == @parent_1_child_2.reload
      end
      
      it "should have the right number of new thread_ids" do
        unique_thread_ids = Message.all.map {|m| m.thread_id}.uniq
        unique_thread_ids.length.should == Message.roots.length
      end
      
      it "should assign the right thread_ids" do
        @parent_2_child_1.reload.thread_id.should == @parent_2.reload.thread_id
        @parent_1_child_2_child_1.reload.thread_id.should == @parent_1_child_2.reload.thread_id
      end

    end
    
  end

end
