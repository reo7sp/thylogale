class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
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
