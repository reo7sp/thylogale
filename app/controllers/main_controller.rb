class MainController < ActionController::Base
  def index
    redirect_to page_folders_path
  end
end
