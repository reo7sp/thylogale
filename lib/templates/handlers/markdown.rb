require 'redcarpet'

module Thylogale::Templates::Handlers
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