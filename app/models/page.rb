class Page < ApplicationRecord
  include RecordWithFile
  include RecordWithFileFrontmatter
  include PgSearch
  include ThylogaleUtils

  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true
  has_many :page_assets, dependent: :destroy

  validates_presence_of :name, :title, :root_folder, :path
  validates_uniqueness_of :path

  before_validation :cache_title_from_metadata, unless: :title?
  before_data_save :cache_title_from_metadata, unless: :title_changed?
  before_save :update_title_in_metadata, if: :title_changed?, prepend: true
  before_data_save :download_external_images, if: :data_changed?

  pg_search_scope :search_by_title, against: :title

  def cleanup_assets
    found_asset_ids = []
    data.match /!\[(.*?)\]\((.*?)\)/ do |match|
      if $2.start_with?('/page_assets/')
        asset_name = $2.rpartition('/').last
        asset_id = asset_name.partition('.').first.to_i
        found_asset_ids << asset_id
      end
    end

    unused_assets = []
    PageAsset.where(page: self).find_each do |asset|
      unused_assets << asset unless asset.id.in?(found_asset_ids)
    end

    unused_assets.each(&:destroy!)
  end

  private

  def cache_title_from_metadata
    self.title = metadata[:title]
  end

  def update_title_in_metadata
    metadata[:title] = title
  end

  def download_external_images
    self.data = data.gsub /!\[(.*?)\]\((.*?)\)/ do |match|
      next match if $2.start_with?('/page_assets/')

      page_asset = PageAsset.create_from_uri!($2, page: self)
      next match unless page_asset
      alt = $1
      src = "/page_assets/#{page_asset.page_id}/#{page_asset.name}"
      "![#{alt}](#{src})"
    end
  end

  class << self

    def publish
      SiteBuilder.build
      Page.find_each(&:cleanup_assets)
    end

  end
end
