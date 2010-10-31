require 'spec_helper'

describe "conversations/show.html.haml" do
  before(:each) do
    @conversation = assign(:conversation, stub_model(Conversation,
      :group_id => 1,
      :subject => "Subject"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/Subject/)
  end
end
