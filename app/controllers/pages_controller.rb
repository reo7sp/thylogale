class PagesController < ApplicationController
  include ThylogaleUtils

  before_action :set_page, only: [:show, :preview, :raw, :publish, :update, :destroy]

  def show
  end

  def preview
    render plain: @page.preview_data, content_type: get_mime_from_file_name(@page.build_path)
  end

  def raw
    render plain: @page.data, content_type: get_mime_from_file_name(@page.name)
  end

  def publish
    @page.publish
    head :ok
  end

  def publish_all
    Page.publish_all
    head :ok
  end

  def create
    @page = Page.new(page_params)

    @page.title.strip!
    @page.root_folder ||= PageFolder.find_by(id: params[:page_folder_id])
    @page.name        ||= "#{@page.title.parameterize}.html.md.erb"
    @page.path        = File.join(@page.root_folder.path, @page.name)
    @page.path        = @page.path[1..-1] if @page.path[0] == '/'

    if @page.save
      render json: {id: @page.id, path: page_path(@page)}, status: :created
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  def update
    if @page.update({published: false}.merge(page_params))
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
