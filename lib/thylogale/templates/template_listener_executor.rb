module Thylogale
  module Templates

    class TemplateListenerExecutor
      include TemplateListenerDSL

      attr_reader :contents, :page

      def initialize(contents, page)
        @contents = contents
        @page     = page
      end
    end

  end
end
