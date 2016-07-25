require 'nokogiri'

module Thylogale
  module Templates
    module Handlers

      class DowngradeHeadings < Base
        register

        def process(contents, page, content_type = :markdown, count: 1)
          case content_type
          when :markdown
            process_markdown(contents, count)
          when :html
            process_html(contents, count)
          end
        end

        private

        def process_markdown(contents, count)
          contents.gsub(/#+/) do |match|
            (match.length + count <= 6) ? "#{match}#{'#' * count}" : '#' * 6
          end
        end

        def process_html(contents, count)
          contents.gsub(/<(\/?)h(\d)>/) do
            slash = $1
            heading_depth = $2.to_i
            (heading_depth + count <= 6) ? "<#{slash}h#{heading_depth + count}>" : "<#{slash}h6>"
          end
        end
      end

    end
  end
end
