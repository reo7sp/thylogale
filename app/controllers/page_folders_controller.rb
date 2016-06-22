class PageFoldersController < ApplicationController
  before_action :set_page_folder, only: [:show, :search, :update, :destroy]

  # GET /page_folders
  # GET /page_folders.json
  def index
    @page_folder = PageFolder.find(1)
    render :show
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

  # POST /page_folders
  # POST /page_folders.json
  def create
    @page_folder = PageFolder.new(page_folder_params)

    if @page_folder.save
      render json: @page_folder, status: :created
    else
      render json: @page_folder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /page_folders/1
  # PATCH/PUT /page_folders/1.json
  def update
    if @page_folder.update(page_folder_params)
      render json: @page_folder, status: :ok
    else
      render json: @page_folder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /page_folders/1
  # DELETE /page_folders/1.json
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
