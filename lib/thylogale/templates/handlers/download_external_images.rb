require 'nokogiri'
require 'base64'
require 'net/http'

module Thylogale
  module Templates
    module Handlers

      class DownloadExternalImages < Base
        register

        def process(contents)
          doc = Nokogiri::HTML(contents)

          doc.xpath('//img').each do |img|
            src = img['src']

            if src.start_with?('data:')
              img['src'] = save_base64_image(src)
            elsif src.start_with?('http')
              img['src'] = save_external_image(src)
            end
          end
        end

        private

        def save_base64_image(src)
          semicolon_index = src.index(';')
          mime            = data[5..semicolon_index]
          contents        = Base64.decode64(data.slice(semicolon_index + 8, -1))
          name            = "#{Thylogale.random_string}.#{get_extension(mime)}"

          asset = PageAsset.create!(name: name, mime: mime, data: contents)
          "/page_assets/#{asset.id}"
        end

        def save_external_image(src)
          uri      = URI(src)
          resp     = Net::HTTP.get_response(uri)
          name     = uri.path.rpartition('/').last
          mime     = resp['Content-Type'] || get_mime_from_file_name(name)
          contents = resp.body

          PageAsset.create!(name: name, mime: mime, data: contents)
          "/page_assets/#{asset.id}"
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
