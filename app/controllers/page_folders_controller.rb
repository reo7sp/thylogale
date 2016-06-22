class PageFoldersController < ApplicationController
  before_action :set_page_folder, only: [:show, :edit, :update, :destroy]

  # GET /page_folders
  # GET /page_folders.json
  def index
    @page_folders = PageFolder.all
  end

  # GET /page_folders/1
  # GET /page_folders/1.json
  def show
  end

  # GET /page_folders/new
  def new
    @page_folder = PageFolder.new
  end

  # GET /page_folders/1/edit
  def edit
  end

  # POST /page_folders
  # POST /page_folders.json
  def create
    @page_folder = PageFolder.new(page_folder_params)

    respond_to do |format|
      if @page_folder.save
        format.html { redirect_to @page_folder, notice: 'Page folder was successfully created.' }
        format.json { render :show, status: :created, location: @page_folder }
      else
        format.html { render :new }
        format.json { render json: @page_folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_folders/1
  # PATCH/PUT /page_folders/1.json
  def update
    respond_to do |format|
      if @page_folder.update(page_folder_params)
        format.html { redirect_to @page_folder, notice: 'Page folder was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_folder }
      else
        format.html { render :edit }
        format.json { render json: @page_folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /page_folders/1
  # DELETE /page_folders/1.json
  def destroy
    @page_folder.destroy
    respond_to do |format|
      format.html { redirect_to page_folders_url, notice: 'Page folder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page_folder
      @page_folder = PageFolder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_folder_params
      params.require(:page_folder).permit(:path)
    end
end
