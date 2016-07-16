require 'redcarpet'

module Thylogale
  module Templates
    module Handlers

      class Markdown < Base
        register

        def initialize
          super
          @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        end

        def process(contents)
          @markdown.render(contents)
        end
      end

    end
  end
end
