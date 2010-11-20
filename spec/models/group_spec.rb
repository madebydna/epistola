require 'spec_helper'

describe Group do
  it "keeps track of number of messages" do
    @group = Factory(:group)
    with_messages = lambda {
      @group.messages.create(Factory.attributes_for(:message))
      @group.reload
    }
    with_messages.should change(@group, :messages_count)
  end
end
