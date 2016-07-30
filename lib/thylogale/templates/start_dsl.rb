module Thylogale
  module Templates

    module StartDSL
      def template(name, &block)
        template = Templates::Base.new(name)
        template.instance_eval(&block)
        template.register
      end

      def template_pipe(name, &block)
        handler = Templates::Handlers::Base.new(name)
        handler.instance_eval(&block)
        handler.register
      end
    end

  end
end

module Thylogale
  extend Templates::StartDSL
end
