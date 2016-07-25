module Thylogale
  module Templates
    module Handlers

      class TemplateLiquid < Base
        register

        def process(contents, page, template_file)
          template_contents = Thylogale.file_container('templates', template_file).read
          template          = Liquid::Template.parse(template_contents)
          template.render(contents: contents, page: page)
        end
      end

    end
  end
end
