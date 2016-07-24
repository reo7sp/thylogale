require_relative 'templates/handlers'
require_relative 'templates/pipe'
require_relative 'templates/base'
require_relative 'templates/start_dsl'
require_relative 'templates/template_listener_dsl'
require_relative 'templates/template_listener'
require_relative 'templates/template_dsl'

module Thylogale
  module Templates

    def self.templates
      load_templates
    end

    def self.register_template(template)
      @templates << template unless @loaded_templates.include?(template)
    end

    def self.load_templates(force: false)
      if @templates.nil? or force
        @templates  = []
        config_file = Thylogale.file_container('config', 'templates.rb').cache(open: false, fast: true)
        load config_file.path, true
      end
      @templates
    end

    class << @templates
      def [](*options)
        case options.first
        when String|Symbol
          name = options.first.to_s
          find { |t| t.name == name }
        else
          super[options]
        end
      end
    end

  end
end

