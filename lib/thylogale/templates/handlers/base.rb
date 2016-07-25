module Thylogale
  module Templates
    module Handlers

      class Base
        def self.handler_name
          name.demodulize.underscore
        end

        def handler_name
          self.class.handler_name
        end

        def register(as: handler_name)
          Handlers.register_handler(as, self)
        end

        def self.register(*constructor_args, as: handler_name)
          new(*constructor_args).register(as: as)
        end
      end

    end
  end
end
