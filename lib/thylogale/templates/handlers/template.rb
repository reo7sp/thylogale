module Thylogale
  module Templates
    module Handlers

      class Template < Base
        register

        def process(contents, template_file, *options)
          handler_name = "template_#{options[:using] || File.extname(template_file)[1..-1]}"
          handler = Handlers.handlers[handler_name]
          handler.process(contents, template_file, options.without(:using))
        end
      end

    end
  end
end
