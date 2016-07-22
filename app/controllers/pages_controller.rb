class PagesController < ApplicationController
  before_action :set_page, only: [:show, :preview, :raw, :update, :destroy]

  def show
  end

  def preview
    # TODO
  end

  def raw
    render plain: @page.data, content_type: Mime::Types.lookup_by_extension(File.extname_without_dot(@page.name))
  end

  def create
    @page = Page.new(page_params)

    @page.title.strip!
    @page.root_folder       ||= PageFolder.find_by(id: params[:page_folder_id])
    @page.template_instance ||= Thylogale::SiteConfigs.templates.first
    @page.name              ||= "#{@page.title.parameterize}.#{@page.template_instance.file_extension}"
    @page.path                = File.join(@page.root_folder.path, @page.name)

    if @page.save
      render json: {id: @page.id, path: page_path(@page)}, status: :created
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  def update
    if @page.update(page_params)
      head :ok
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @page.destroy
    head :ok
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :name, :template, :root_folder_id, :data)
  end
end
