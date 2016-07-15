module Thylogale::Templates::Handlers
  class Template < Base
    register

    def process(contents, template_file, *options)
      handler_name = "template_#{options[:using] || template_file.rpartition('.').last}"
      handler = Handlers.handlers[handler_name]
      handler.process(contents, template_file, options.without(:using))
    end
  end
end