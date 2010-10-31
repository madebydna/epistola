require 'spec_helper'

describe "conversations/edit.html.haml" do
  before(:each) do
    @conversation = assign(:conversation, stub_model(Conversation,
      :new_record? => false,
      :group_id => 1,
      :subject => "MyString"
    ))
  end

  it "renders the edit conversation form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => conversation_path(@conversation), :method => "post" do
      assert_select "input#conversation_group_id", :name => "conversation[group_id]"
      assert_select "input#conversation_subject", :name => "conversation[subject]"
    end
  end
end
