require 'rails_helper'

RSpec.describe "Assets", type: :request do
  describe "GET /assets" do
    it "works! (now write some real specs)" do
      get assets_path
      expect(response).to have_http_status(200)
    end
  end
end
