module Thylogale
  module Templates
    module Handlers

      class Base
        def self.name
          super.demodulize.underscore
        end

        protected

        def self.register(as: name)
          Handlers.register_handler(as, new)
        end
      end

    end
  end
end
