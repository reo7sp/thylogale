class PageFoldersController < ApplicationController
  before_action :set_page_folder, only: [:show, :update, :destroy]

  def index
    redirect_to PageFolder.root
  end

  def show
  end

  def create
    @page_folder = PageFolder.new(page_folder_params)

    @page_folder.title.strip!
    @page_folder.root_folder ||= PageFolder.find_by(id: params[:id])
    @page_folder.name        ||= @page_folder.title.parameterize
    @page_folder.path        = File.join(@page_folder.root_folder.path, @page_folder.name)
    @page_folder.path        = @page_folder.path[1..-1] if @page_folder.path[0] == '/'

    if @page_folder.save
      render json: {id: @page_folder.id, path: page_folder_path(@page_folder)}, status: :created
    else
      render json: @page_folder.errors, status: :unprocessable_entity
    end
  end

  def update
    if @page_folder.update(page_folder_params)
      head :ok
    else
      render json: @page_folder.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @page_folder.destroy
    head :ok
  end

  private

  def set_page_folder
    @page_folder = PageFolder.find(params[:id])
  end

  def page_folder_params
    params.require(:page_folder).permit(:title, :name, :root_folder_id)
  end
end
