module Thylogale
  module SiteConfigs
    @templates = []

    def self.templates
      load_templates
    end

    def self.load_templates(force: false)
      if @templates.empty? or force
        @templates = []
        config_file = Thylogale.file_container('config', 'templates.rb').cache
        load config_file.path, true
      end
      @templates
    end
  end
end

