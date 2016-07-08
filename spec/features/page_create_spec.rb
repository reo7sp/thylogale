require 'rails_helper'
require 'fileutils'

RSpec.describe 'creates new pages and folders', type: :feature do
  before :all do
    ENV['SITES_DEFAULT_LOCATION'] = "/tmp/thylogale-test-#{Random.rand}"
  end

  before :each do
    FileUtils.mkdir_p ENV['SITES_DEFAULT_LOCATION']
  end

  after :each do
    # page.driver.clear_memory_cache
    FileUtils.rm_r ENV['SITES_DEFAULT_LOCATION']
  end

  it 'creates page' do |ctx|
    complete_first_setup(ctx)

    click_button 'New page'
    new_page_title = "test-file-#{Random.rand}"
    accept_prompt with: new_page_title

    find 'td', text: new_page_title
    expect(Page.find(title: new_page_title)).not_to be nil
  end
end
