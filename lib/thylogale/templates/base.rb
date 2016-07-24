module Thylogale
  module Templates

    class Base
      include TemplatesDSL

      attr_reader :name

      def initialize(name)
        @name                 = name
        @on_save_listeners    = []
        @on_publish_listeners = []
      end

      def process_save(contents)
        process(contents, @on_save_listeners)
      end

      def process_publish(contents)
        process(contents, @on_publish_listeners)
      end

      def register
        Templates.templates_loader.register_template(self)
      end

      private

      def process(contents, listeners)
        listeners.reduce(contents) do |memo, listener|
          listener.process(memo)
        end
      end
    end

  end
end
