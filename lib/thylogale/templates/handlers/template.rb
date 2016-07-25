module Thylogale
  module Templates
    module Handlers

      class Template < Base
        register

        def process(contents, page, template_file, *options)
          template_name = options[:using] || File.extname_without_dot(template_file)
          handler_name  = "template_#{template_name}"
          handler       = Handlers.handlers[handler_name]
          handler.process(contents, page, *options.without(:using))
        end
      end

    end
  end
end
