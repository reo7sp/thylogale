module Thylogale
  module Templates

    class Pipe
      attr_reader :handler, :options

      def initialize(handler, *options)
        @handler = handler
        @options = options
      end
    end

  end
end
