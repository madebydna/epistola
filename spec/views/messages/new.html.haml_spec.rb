require 'spec_helper'

describe "messages/new.html.haml" do
  before(:each) do
    assign(:message, stub_model(Message,
      :conversation_id => 1,
      :user => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new message form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => messages_path, :method => "post" do
      assert_select "input#message_conversation_id", :name => "message[conversation_id]"
      assert_select "input#message_user", :name => "message[user]"
      assert_select "textarea#message_body", :name => "message[body]"
    end
  end
end
