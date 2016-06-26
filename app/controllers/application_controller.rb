class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_first_setup
  before_action :check_setup

  private

  def set_first_setup
    @first_setup = FirstSetup.first
  end

  def check_setup
    case params[:controller]
      when FirstSetupsController.controller_name
        redirect_to page_folders_path if @first_setup.done
      else
        redirect_to setup_path unless @first_setup.done
    end
  end
end
