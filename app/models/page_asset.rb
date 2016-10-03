class PageAsset < ApplicationRecord
  include RecordWithFile
  include ThylogaleUtils

  belongs_to :page, touch: true, counter_cache: true

  validates_presence_of :name, :mime, :page
  validates_format_of :name, with: /\A.+\..+\z/
  validates_format_of :mime, with: /\A.+\/.+\z/

  def root_abs_path
    File.join(PageFolder.root.abs_path, 'assets')
  end

  def path
    File.join(page_id, name)
  end

  def path_was
    File.join(page_id_was, name_was)
  end

  def path_changed?
    page_id_changed? or name_changed?
  end

  class << self
    def create_from_uri!(uri, page:)
      if src.start_with?('data:')
        create_from_base64_uri!(uri, page: page)
      elsif src.start_with?('http')
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
      name            = "#{random_string}.#{get_extension(mime)}"
      PageAsset.create!(name: name, mime: mime, data: contents, page: page)
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
      PageAsset.create!(name: name, mime: mime, data: contents, page: page)
    end

    def create_from_http_uri(uri, page:)
      create_from_http_uri!(uri, page: page) rescue nil
    end
  end
end
