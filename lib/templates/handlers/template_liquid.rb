require 'file_containers'
require 'liquid'

module Thylogale::Templates::Handlers
  class TemplateLiquid < Base
    register

    def process(contents, template_file)
      template_contents = Thylogale.file_container('templates', template_file).read
      @template = Liquid::Template.parse(template_contents)
      @template.render(contents: contents)
    end
  end
end