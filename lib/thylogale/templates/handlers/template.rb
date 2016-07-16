module Thylogale
  module Templates
    module Handlers

      class Template < Base
        register

        def process(contents, template_file, *options)
          handler_name = "template_#{options[:using] || get_extname(template_file)}"
          handler = Handlers.handlers[handler_name]
          handler.process(contents, template_file, options.without(:using))
        end

        private

        def get_extname(file)
          File.extname(file)[1..-1]
        end
      end

    end
  end
end
