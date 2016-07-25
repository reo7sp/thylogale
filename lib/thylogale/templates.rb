require_relative 'templates/handlers'
require_relative 'templates/pipe'
require_relative 'templates/start_dsl'
require_relative 'templates/template_listener_dsl'
require_relative 'templates/template_listener_executor'
require_relative 'templates/template_listener'
require_relative 'templates/template_dsl'
require_relative 'templates/templates_loader'
require_relative 'templates/base'

module Thylogale
  module Templates

    def self.templates_loader
      @templates_loader ||= TemplatesLoader.new
    end

    def self.templates
      templates_loader.templates
    end

  end
end

