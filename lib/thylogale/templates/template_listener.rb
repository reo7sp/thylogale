module Thylogale
  module Templates

    class TemplateListener
      def initialize(proc)
        @proc = proc
      end

      def process(contents)
        executor = TemplateListenerDSL.new(contents)
        executor.instance_eval(&@proc)
      end
    end

  end
end
