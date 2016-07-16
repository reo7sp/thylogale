module Thylogale
  module Templates
    module Handlers

      class Base
        def name
          self.class.to_s.demodulize.underscore
        end

        protected

        def self.register(as: name)
          Handlers.register_handler(as, new)
        end
      end

    end
  end
end
