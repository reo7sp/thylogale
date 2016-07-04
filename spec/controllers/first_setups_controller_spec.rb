require 'rails_helper'
require 'tempfile'
require 'zip'

RSpec.describe FirstSetupsController, type: :controller do
  include Capybara::DSL

  describe 'GET #setup' do
    before :each do
      visit '/'
      expect(page).to have_current_path(setup_path)
    end

    after :all do
      FirstSetup.destroy_all
    end

    describe 'client form checks' do
      context 'ok admin user creditinals' do
        before :each do
          fill_in '#admin_user_password', with: '1234'
          fill_in '#admin_user_password_confirmation', with: '1234'
          fill_in '#admin_user_email', with: 'example@example.com'
        end

        it 'chooses no radio buttons' do
          expect(find_button('Finish setup').disabled?).to be false
        end

        context 'import from' do
          it 'select multiple times' do
            states = [['#first_setup_import_choice_new', true], ['#first_setup_import_choice_upload', false]]
            check_states(states, &:choose_radio_and_finish)
          end

          it 'selects zip file' do
            choose '#first_setup_import_choice_upload'
            attach_file '#first_setup_import_file', generate_zip_file_with_site.path
            expect(find_button('Finish setup').disabled?).to be false
            click_button 'Finish setup'
            # TODO: test zip file parsing
          end
        end

        context 'save on' do
          it 'selects multiple times' do
            states = [['#first_setup_save_choice_local', true], ['#first_setup_save_choice_s3', false]]
            check_states(states, &:choose_radio_and_finish)
          end
        end

        context 'send email from' do
          it 'selects multiple times' do
            states = [['#first_setup_email_choice_local', true], ['#first_setup_email_choice_mailgun', false]]
            check_states(states, &:choose_radio_and_finish)
          end
        end
      end

      context 'not ok admin user creditinals' do
        it 'does nothing' do
          expect(find_button('Finish setup').disabled?).to be true
        end

        it 'sets no password' do
          fill_in '#admin_user_email', with: 'example@example.com'
          expect(find_button('Finish setup').disabled?).to be true
        end

        it 'sets wrong password confirmation' do
          fill_in '#admin_user_password', with: '1234'
          fill_in '#admin_user_password_confirmation', with: 'different'
          fill_in '#admin_user_email', with: 'example@example.com'
          expect(find_button('Finish setup').disabled?).to be true
        end

        it 'sets wrong email' do
          fill_in '#admin_user_password', with: '1234'
          fill_in '#admin_user_password_confirmation', with: '1234'
          fill_in '#admin_user_email', with: 'something'
          expect(find_button('Finish setup').disabled?).to be true
        end
      end
    end
  end
end

def generate_zip_file_with_site
  result_file = Tempfile.new('test-site')
  Zip::File.open(result_file.path) do |f|
    index_html = Tempfile.new('index.html')
    index_html.write('Hi there')
    f.add('index.html', index_html.path)
  end
  result_file
end

def check_states(states, times: 10)
  times.times do
    state = states.sample
    yield(*state)
  end
end

def choose_radio_and_finish(radio, can_finish = true)
  choose radio
  expect(find_button('Finish setup').disabled?).to be can_finish
  click_button 'Finish setup' if can_finish
end
