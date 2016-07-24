module Thylogale
  module Templates

    class TemplatesLoader
      def templates
        load_templates
      end

      def load_templates(force: false)
        if @templates.nil? or force
          @templates = TemplatesArray.new
          config_file = Thylogale.file_container('config', 'templates.rb').cache(open: false, fast: true)
          load config_file.path, true
        end
        @templates
      end

      def register_template(template)
        @templates << template unless @templates.include?(template)
      end

      private

      class TemplatesArray < Array
        def [](*options)
          case options.first
          when String, Symbol
            name = options.first.to_s
            find { |t| t.name == name }
          else
            super[options]
          end
        end
      end
    end

  end
end
