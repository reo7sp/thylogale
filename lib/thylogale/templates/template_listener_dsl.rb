module Thylogale
  module Templates

    module TemplateListenerDSL
      def make_pipe(*options, &block)
        case options.first
        when Symbol, String
          handler                 = options.fetch(0)
          handler_options         = options.drop(1)
          handler_options[:block] = block if block_given?
          Pipe.new(Handlers.handlers[handler], handler_options)
        when Handlers::Base
          Pipe.new(options.first, options.drop(1))
        else
          Pipe.new(Handlers::Proc.new(block), options) if block_given?
        end
      end

      def pipe(*options, &block)
        make_pipe(*options, &block).process(contents, page)
      end
    end

  end
end
