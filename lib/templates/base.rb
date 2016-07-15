require 'templates/handlers'

module Thylogale::Templates
  class Base
    attr_reader :name
    attr_accessor :file_extension

    alias_method :file_extension, :file_extension=

    def initialize(name)
      @name  = name
      @pipes = []
    end

    def pipe(handler, *options)
      @pipes << { handler: Handlers.handlers[handler], options: options }
    end
  end
end
