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

      def process_save(page)
        process(page, @on_save_listeners)
      end

      def process_publish(page)
        process(page, @on_publish_listeners)
      end

      def register
        Templates.templates_loader.register_template(self)
      end

      private

      def process(page, listeners)
        listeners.reduce(page.data) do |memo, listener|
          listener.process(memo, page)
        end
      end
    end

  end
end
