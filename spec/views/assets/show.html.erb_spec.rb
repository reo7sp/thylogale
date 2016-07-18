require 'rails_helper'

RSpec.describe "assets/show", type: :view do
  before(:each) do
    @asset = assign(:asset, Asset.create!(
      :name => "Name",
      :page => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
