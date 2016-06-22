class PagesController < ApplicationController
  before_action :set_page, only: [:show, :preview, :raw, :update, :destroy]

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/1/preview
  def preview
    # TODO
  end

  # GET /pages/1/raw
  def raw
    # TODO
  end

  # POST /page_folders/1/pages
  # POST /page_folders/1/pages.json
  def create
    @page = Page.new(page_params)

    if @page.save
      render json: @page, status: :ok
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    if @page.update(page_params)
      render json: @page, status: :ok
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :name, :template, :root_folder_id)
    end
end
