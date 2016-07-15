Rails.application.config.browserify_rails.commandline_options = '-t coffeeify --fast'
Rails.application.config.browserify_rails.paths << 'lib/assets/javascripts'
Rails.application.config.browserify_rails.source_map_environments << 'development'
