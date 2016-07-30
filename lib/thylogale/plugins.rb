module Thylogale
  module Plugins

    class PluginsLoader
      def load_plugins(force: false)
        return unless !@plugins_loaded or force
        @plugins_loaded = true
        Thylogale.file_container('plugins').ls.each do |c|
          f = c.cache(open: false, fast: true)
          load f.path, true
        end
      end
    end

  end
end