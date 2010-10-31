require 'spec_helper'

describe "conversations/index.html.haml" do
  before(:each) do
    assign(:conversations, [
      stub_model(Conversation,
        :group_id => 1,
        :subject => "Subject"
      ),
      stub_model(Conversation,
        :group_id => 1,
        :subject => "Subject"
      )
    ])
  end

  it "renders a list of conversations" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
  end
end
