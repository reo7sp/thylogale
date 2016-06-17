class PageFoldersController < ApplicationController
  before_action :set_page_folder, only: [:show, :update, :destroy]

  # GET /pages
  def index
    @page_folder = PageFolder.find('')
    render :show
  end

  # GET /pages/1
  def show
  end

  # POST /pages
  def create
    @page_folder = PageFolder.new(page_folder_params)

    if @page_folder.save
      render json: { status: :ok }
    else
      render json: { errors: @page_folder.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pages/1
  def update
    if @page_folder.update(page_folder_params)
      render json: { status: :ok }
    else
      render json: { errors: @page_folder.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /pages/1
  def destroy
    if @page_folder.destroy
      render json: { status: :ok }
    else
      render json: { errors: @page_folder.errors }, status: :unprocessable_entity
    end
  end

  private
    def set_page_folder
      @page_folder = PageFolder.find(params[:id])
    end

    def page_folder_params
      params.require(:page_folder).permit(:name, :location)
    end
end
