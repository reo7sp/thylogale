class PagesController < ApplicationController
  before_action :set_page, only: [:show, :preview, :raw, :update, :destroy]

  def show
  end

  def preview
    # TODO
  end

  def raw
    render plain: @page.data, content_type: get_mime_from_file_name(@page.name)
  end

  def publish
    Page.publish
  end

  def create
    @page = Page.new(page_params)

    @page.title.strip!
    @page.root_folder       ||= PageFolder.find_by(id: params[:page_folder_id])
    @page.name              ||= "#{@page.title.parameterize}.html.md.erb"
    @page.path              = File.join(@page.root_folder.path, @page.name)

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

  def get_mime(extension)
    Mime::Type.lookup_by_extension(extension)
  end

  def get_mime_from_file_name(file_name)
    get_mime(File.extname_without_dot(file_name))
  end
end
