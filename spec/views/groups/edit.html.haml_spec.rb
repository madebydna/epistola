require 'spec_helper'

describe "groups/edit.html.haml" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :new_record? => false,
      :name => "MyString"
    ))
  end

  it "renders the edit group form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => group_path(@group), :method => "post" do
      assert_select "input#group_name", :name => "group[name]"
    end
  end
end
