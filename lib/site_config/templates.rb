require 'file_containers'

module Thylogale
  module SiteConfigs
    def load_templates
      config_file = Thylogale.file_container('config', 'templates.rb').cache
      require 'templates/dsl'
      load(config_file.path, true)
    end
  end
end