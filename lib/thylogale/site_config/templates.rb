module Thylogale
  module SiteConfigs
    @templates = Object.new
    class << @templates
      include Enumerable

      def each(*options, &block)
        SiteConfigs._loaded_templates.each(*options, &block)
      end

      def <=>(other)
        SiteConfigs._loaded_templates.<=>(other)
      end

      def [](name)
        find { |t| t.name == name }
      end
    end

    def self.templates
      load_templates
    end

    def self._loaded_templates
      @_loaded_templates
    end

    def self.load_templates(force: false)
      if @_loaded_templates.nil? or force
        @_loaded_templates = []
        config_file = Thylogale.file_container('config', 'templates.rb').cache
        load config_file.path, true
      end
      @templates
    end
  end
end

