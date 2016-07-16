module Thylogale
  module Templates

    class Base
      attr_reader :name

      def initialize(name)
        @name  = name
        @pipes = []
      end

      def pipe(handler, *options)
        @pipes << { handler: Handlers.handlers[handler], options: options }
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
