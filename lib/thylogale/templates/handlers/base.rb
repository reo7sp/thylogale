module Thylogale
  module Templates
    module Handlers

      class Base
        def self.name
          super.demodulize.underscore
        end

        def register(as: self.class.name)
          Handlers.register_handler(as, self)
        end

        def self.register(*constructor_args, as: name)
          new(*constructor_args).register(as: as)
        end
      end

    end
  end
end
