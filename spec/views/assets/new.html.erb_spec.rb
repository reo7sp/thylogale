require 'rails_helper'

RSpec.describe "assets/new", type: :view do
  before(:each) do
    assign(:asset, Asset.new(
      :name => "MyString",
      :page => nil
    ))
  end

  it "renders new asset form" do
    render

    assert_select "form[action=?][method=?]", assets_path, "post" do

      assert_select "input#asset_name[name=?]", "asset[name]"

      assert_select "input#asset_page_id[name=?]", "asset[page_id]"
    end
  end
end
