module FirstSetupHelpers
  def complete_first_setup(ctx)
    case ctx.metadata[:type]
      when :controller
        options = {
            first_setup: {
                import_choice: 'local',
                save_choice: 'local',
                email_choice: 'local'
            },
            admin_user: {
                password: '1234',
                password_confirmation: '1234',
                email: 'example@example.com'
            }
        }
        post '/setup', options

      when :feature
        page.driver.clear_memory_cache
        visit '/'
        fill_in 'admin_user_password', with: '1234'
        fill_in 'admin_user_password_confirmation', with: '1234'
        fill_in 'admin_user_email', with: 'example@example.com'
        click_button 'first_setup_finish_btn'
    end
  end
end
