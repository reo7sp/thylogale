require 'rails_helper'

RSpec.describe Page, type: :model do
  before :each do
    complete_first_setup
  end

  after :each do
    FileUtils.rm_r(File.join(@first_setup.save_local_dir, @root_folder.path)) rescue nil
  end

  describe '.create' do
    it do
      expect(create(:page)).not_to be nil
      expect(Page.count).to eq 1
    end

    it 'cannot create pages with same path' do
      create(:page)
      expect { create(:page) }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
