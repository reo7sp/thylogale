module Thylogale
  module Templates

    class TemplateListener
      def initialize(proc)
        @proc = proc
      end

      def process(contents, page)
        executor = TemplateListenerExecutor.new(contents, page)
        executor.instance_eval(&@proc)
      end
    end

  end
end
