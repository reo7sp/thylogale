require 'rails_helper'

RSpec.describe "assets/index", type: :view do
  before(:each) do
    assign(:assets, [
      Asset.create!(
        :name => "Name",
        :page => nil
      ),
      Asset.create!(
        :name => "Name",
        :page => nil
      )
    ])
  end

  it "renders a list of assets" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
