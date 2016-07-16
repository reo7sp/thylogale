class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_first_setup
  before_action :check_setup, if: "request.path != setup_path"

  private

  def set_first_setup
    @first_setup = FirstSetup.instance
  end

  def check_setup
    redirect_to setup_path unless @first_setup.done
  end
end
