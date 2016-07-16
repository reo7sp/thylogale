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
  def create
    @page = Page.new(page_params)

    @page.title.strip!
    @page.root_folder ||= PageFolder.find_by(id: params[:page_folder_id])
    @page.template_instance ||= Thylogale::SiteConfigs.templates.first
    @page.name ||= "#{@page.title.parameterize}.#{template.file_extension}"
    @page.path = File.join(@page.root_folder.path, @page.name)

    if @page.save
      head :created
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      head :ok
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
    head :ok
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :name, :template, :root_folder_id)
  end
end
