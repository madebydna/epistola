require 'spec_helper'

describe "messages/edit.html.haml" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :new_record? => false,
      :conversation_id => 1,
      :user => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => message_path(@message), :method => "post" do
      assert_select "input#message_conversation_id", :name => "message[conversation_id]"
      assert_select "input#message_user", :name => "message[user]"
      assert_select "textarea#message_body", :name => "message[body]"
    end
  end
end
