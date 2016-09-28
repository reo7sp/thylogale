class Page < ApplicationRecord
  include RecordWithFileContainer
  include PgSearch
  include ThylogaleUtils

  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true
  has_many :page_assets, dependent: :destroy

  validates_presence_of :name, :title, :root_folder, :template, :path
  validates_uniqueness_of :path

  before_save :download_external_images, if: :data_changed?

  pg_search_scope :search_by_title, against: :title

  def file_container
    @file_container ||= FileContainer.new(File.join('source', path))
  end

  def publish
    # TODO: run middleman build
  end

  private

  def download_external_images
    self.data = data.gsub /!\[(.*?)\]\((.*?)\)/ do |match|
      page_asset = PageAsset.create_from_uri($2, page)
      next match unless page_asset

      alt = $1
      src = "/page_assets/#{page_asset.id}/raw"
      "![#{alt}](#{src})"
    end
  end
end
