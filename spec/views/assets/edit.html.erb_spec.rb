require 'rails_helper'

RSpec.describe "assets/edit", type: :view do
  before(:each) do
    @asset = assign(:asset, Asset.create!(
      :name => "MyString",
      :page => nil
    ))
  end

  it "renders the edit asset form" do
    render

    assert_select "form[action=?][method=?]", asset_path(@asset), "post" do

      assert_select "input#asset_name[name=?]", "asset[name]"

      assert_select "input#asset_page_id[name=?]", "asset[page_id]"
    end
  end
end
