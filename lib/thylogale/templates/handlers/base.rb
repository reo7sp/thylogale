module Thylogale
  module Templates
    module Handlers

      class Base
        def self.name
          super.demodulize.underscore
        end

        protected

        def self.register(*constructor_args, as: name)
          Handlers.register_handler(as, new(*constructor_args))
        end
      end

    end
  end
end
