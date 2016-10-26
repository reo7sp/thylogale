class PageAsset < ApplicationRecord
  include RecordWithFile
  include RecordWithBuildableFile
  include ThylogaleUtils

  belongs_to :page, touch: true, counter_cache: true

  validates_presence_of :mime, :page
  validates_format_of :mime, with: /\A.+\/.+\z/

  def root_abs_path
    File.join(PageFolder.root.abs_path, 'page_assets')
  end

  def extension
    get_extension(mime)
  end

  def extension_was
    get_extension(mime_was)
  end

  def extension_changed?
    mime_changed?
  end

  def name
    "#{id}.#{extension}"
  end

  def name_was
    "#{id}.#{extension_was}"
  end

  def name_changed?
    extension_changed?
  end

  def path
    File.join(page_id.to_s, name)
  end

  def path_was
    File.join(page_id_was.to_s, name_was)
  end

  def path_changed?
    page_id_changed? or name_changed?
  end

  class << self
    def create_from_uri!(uri, page:)
      if uri.start_with?('data:')
        create_from_base64_uri!(uri, page: page)
      elsif uri.start_with?('http')
        create_from_http_uri!(uri, page: page)
      end
    end

    def create_from_uri(uri, page:)
      create_from_uri!(uri, page: page) rescue nil
    end

    def create_from_base64_uri!(uri, page:)
      semicolon_index = uri.index(';')
      mime            = uri[5...semicolon_index]
      contents        = Base64.decode64(uri[semicolon_index + 8..-1])
      PageAsset.create!(mime: mime, data: contents, page: page)
    end

    def create_from_base64_uri(uri, page:)
      create_from_base64_uri!(uri, page: page) rescue nil
    end

    def create_from_http_uri!(uri, page:)
      uri      = URI(uri)
      resp     = Net::HTTP.get_response(uri)
      name     = uri.path.rpartition('/').last
      mime     = resp['Content-Type'] || get_mime_from_file_name(name)
      contents = resp.body
      PageAsset.create!(mime: mime, data: contents, page: page)
    end

    def create_from_http_uri(uri, page:)
      create_from_http_uri!(uri, page: page) rescue nil
    end
  end
end
