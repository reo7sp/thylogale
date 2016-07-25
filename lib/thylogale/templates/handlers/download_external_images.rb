require 'nokogiri'
require 'base64'
require 'net/http'

module Thylogale
  module Templates
    module Handlers

      class DownloadExternalImages < Base
        register

        def process(contents, page, contents_type = :markdown)
          case contents_type
          when :markdown
            process_markdown(contents, page)
          when :html
            process_html(contents, page)
          end
        end

        private

        def process_markdown(contents, page)
          contents.gsub /!\[(.*?)\]\((.*?)\)/ do |match|
            page_asset = save_image($2, page)
            return match unless page_asset

            alt = $1
            src = page_asset_path(page_asset)
            "![#{alt}](#{src})"
          end
        end

        def process_html(contents, page)
          doc = Nokogiri::HTML(contents)
          doc.xpath('//img').each do |img|
            img['src'] = page_asset_path(save_image(img['src'], page))
          end
          doc.to_html
        end

        def page_asset_path(asset)
          "/page_assets/#{asset.id}/raw"
        end

        def save_image(src, page)
          if src.start_with?('data:')
            save_base64_image(src, page)
          elsif src.start_with?('http')
            save_external_image(src, page)
          end
        end

        def save_base64_image(src, page)
          semicolon_index = src.index(';')
          mime            = data[5..semicolon_index]
          contents        = Base64.decode64(data.slice(semicolon_index + 8, -1))
          name            = "#{Thylogale.random_string}.#{get_extension(mime)}"
          PageAsset.create!(name: name, mime: mime, data: contents, page: page)
        end

        def save_external_image(src, page)
          uri      = URI(src)
          resp     = Net::HTTP.get_response(uri)
          name     = uri.path.rpartition('/').last
          mime     = resp['Content-Type'] || get_mime_from_file_name(name)
          contents = resp.body
          PageAsset.create!(name: name, mime: mime, data: contents, page: page)
        end

        def get_mime(extension)
          Mime::Type.lookup_by_extension(extension)
        end

        def get_mime_from_file_name(file_name)
          get_mime(File.extname_without_dot(file_name))
        end

        def get_extension(mime)
          Mime::Type.lookup(mime).to_sym
        end
      end

    end
  end
end
