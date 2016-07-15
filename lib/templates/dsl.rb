require 'templates/base'
require 'templates/handlers'

module Thylogale
  module Templates
    @templates = []
    attr_accessor :templates
  end

  def template(name, &block)
    Templates.templates << Templates::Base.new(name).instance_eval(&block)
  end
end