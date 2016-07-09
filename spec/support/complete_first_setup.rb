module FirstSetupHelpers
  def complete_first_setup
    @first_setup = create(:done_first_setup)
    @root_folder = create(:root_page_folder)
    @admin_user = create(:admin_user)
  end
end

RSpec.configure do |config|
  config.include FirstSetupHelpers
end
