require 'rails_helper'

RSpec.describe PageFolder, type: :model do
  before :each do
    complete_first_setup
  end

  after :each do
    FileUtils.rm_r(File.join(@first_setup.save_local_dir, @root_folder.path)) rescue nil
  end

  describe '.create' do
    it do
      expect(create(:page_folder)).not_to be nil
      expect(PageFolder.count).to eq 2
    end

    it 'cannot create page folders with same path' do
      create(:page_folder)
      expect { create(:page_folder) }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
