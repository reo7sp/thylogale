module Thylogale
  module Templates

    module TemplatesDSL
      def on_save(&block)
        @on_save_listeners << TemplateListener.new(block)
      end

      def on_publish(&block)
        @on_publish_listeners << TemplateListener.new(block)
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
