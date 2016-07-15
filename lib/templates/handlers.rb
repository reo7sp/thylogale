require_relative 'handlers/base'
require_relative 'handlers/markdown'
require_relative 'handlers/template'
require_relative 'handlers/template_liquid'

module Thylogale::Templates::Handlers
  @handlers = ActiveSupport::HashWithIndifferentAccess.new

  def self.register_handler(name, handler)
    @handlers[name] = handler
  end

  def self.handlers
    @handlers
  end
end