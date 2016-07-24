class PageAssetsController < ApplicationController
  before_action :set_asset, only: [:show, :raw, :update, :destroy]

  def show
    respond_to do |format|
      format.html { redirect_to raw_page_asset_path }
      format.json
    end
  end

  def raw
    render plain: @page_asset.data, content_type: get_mime_from_file_name(@page_asset.name)
  end

  def create
    @page_asset = PageAsset.new(page_asset_params)

    @page_asset.mime = page_asset_params[:data].content_type
    @page_asset.name ||= "#{Random.string}.#{get_extension(@page_asset.mime)}"

    if @page_asset.save
      render json: {id: @page_asset.id, path: page_asset_path(@page_asset)}, status: :created
    else
      render json: @page_asset.errors, status: :unprocessable_entity
    end
  end

  def update
    if @page_asset.update(page_asset_params)
      head :ok
    else
      render json: @page_asset.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @page_asset.destroy
    head :ok
  end

  private

  def set_asset
    @page_asset = PageAsset.find(params[:id])
  end

  def page_asset_params
    params.require(:page_asset).permit(:name, :page_id, :data)
  end
end
