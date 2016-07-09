require 'rails_helper'

RSpec.describe 'Completing first setup', type: :feature, js: true do
  before :all do
    ENV['SITE_DOMAIN'] = 'example.com'
  end

  after :each do
    page.driver.clear_memory_cache
  end

  context 'simple' do
    it do
      def expect_finish_disabled(yes = true)
        expect(find_by_id('first_setup_finish_btn').disabled?).to be yes
      end

      visit '/'
      expect(page).to have_current_path(setup_path)
      expect(page.status_code).to eq 200

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
end
