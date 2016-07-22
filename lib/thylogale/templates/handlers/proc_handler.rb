module Thylogale
  module Templates
    module Handlers

      class ProcHandler < Base
        def initialize(proc)
          super
          @proc = proc
        end

        def process(*options)
          @proc.call(*options)
        end
      end

    end
  end
end
