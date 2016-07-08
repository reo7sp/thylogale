require 'rails_helper'

RSpec.describe 'first setup', type: :feature do
  before :all do
    ENV['SITE_DOMAIN'] = 'example.com'
  end

  it 'completes simple setup' do
    def expect_finish_disabled(yes = true)
      expect(find_by_id('first_setup_finish_btn').disabled?).to be yes
    end

    visit '/'
    expect(page).to have_current_path(setup_path)

    expect_finish_disabled
    fill_in 'admin_user_password', with: '1234'
    expect_finish_disabled
    fill_in 'admin_user_password_confirmation', with: '1234'
    expect_finish_disabled
    fill_in 'admin_user_email', with: 'example@example.com'
    expect_finish_disabled false

    click_button 'first_setup_finish_btn'

    expect(page).to have_current_path(page_folder_path(1))
  end
end
