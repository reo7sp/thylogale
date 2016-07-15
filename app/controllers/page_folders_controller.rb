class PageFoldersController < ApplicationController
  before_action :set_page_folder, only: [:show, :search, :update, :destroy]

  # GET /page_folders
  # GET /page_folders.json
  def index
    redirect_to PageFolder.root
  end

  # GET /page_folders/1
  # GET /page_folders/1.json
  def show
  end

  # GET /page_folders/1/search
  def search
    # TODO
    render json: []
  end

  # POST /page_folders/1
  def create
    @page_folder = PageFolder.new(page_folder_params)
    @page_folder.title.strip!
    @page_folder.root_folder ||= PageFolder.find_by(id: params[:id])
    @page_folder.default_template ||= @page_folder.root_folder.default_template
    @page_folder.name ||= @page_folder.title.parameterize
    @page_folder.path = File.join(@page_folder.root_folder.path, @page_folder.name)

    if @page_folder.save
      head :created
    else
      render json: @page_folder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /page_folders/1
  def update
    if @page_folder.update(page_folder_params)
      head :ok
    else
      render json: @page_folder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /page_folders/1
  def destroy
    @page_folder.destroy
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page_folder
    @page_folder = PageFolder.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_folder_params
    params.require(:page_folder).permit(:title, :name, :root_folder_id)
  end
end
