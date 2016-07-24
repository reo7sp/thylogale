module Thylogale
  module Templates

    module StartDSL
      def template(name, &block)
        template = Templates::Base.new(name)
        template.instance_eval(&block)
        template.register
      end
    end

  end
end

module Thylogale
  extend Templates::StartDSL
end
