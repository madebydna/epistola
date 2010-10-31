require 'spec_helper'

describe "conversations/new.html.haml" do
  before(:each) do
    assign(:conversation, stub_model(Conversation,
      :group_id => 1,
      :subject => "MyString"
    ).as_new_record)
  end

  it "renders new conversation form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => conversations_path, :method => "post" do
      assert_select "input#conversation_group_id", :name => "conversation[group_id]"
      assert_select "input#conversation_subject", :name => "conversation[subject]"
    end
  end
end
