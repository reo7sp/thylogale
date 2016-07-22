module Thylogale
  module Templates

    class Base
      attr_reader :name

      def initialize(name)
        @name  = name
        @pipes = []
      end

      def pipe(*options, &block)
        if block_given?
          @pipes << Pipe.new(Handlers::ProcHandler.new(block), options)
        else
          handler = options.fetch(0)
          handler_options = options.drop(1)
          @pipes << Pipe.new(Handlers.handlers[handler], handler_options)
        end
      end

      def file_extension(extension = nil)
        if extension.nil?
          @file_extension
        else
          @file_extension = extension
        end
      end

      def file_extension=(extension)
        @file_extension = extension
      end
    end

  end
end
