module SiteBuilder
  class FileMetadata < Struct.new(:metadata, :data)
  end

  class BuildError < StandardError
    attr_reader :file

    def initialize(message, file)
      super(message)
      @file = file
    end
  end

  class << self
    def build
      Dir.chdir(middleman_root_dir) do
        output = `BUNDLE_GEMFILE="./Gemfile" middleman build --verbose`
        if $?.exitstatus != 0
          output =~ /\s+error\s*(.+?)\s*\r?\n(.+?)(for #<.+?>)?\r?\n/
          file = $1
          message = $2
          raise BuildError.new(message, file)
        end
      end
    end

    def parse_file(path, app: new_middleman)
      source_file    = Middleman::SourceFile.new(nil, path, nil, {}, nil)
      metadata, data = Middleman::Util::Data::parse(source_file, app.config[:frontmatter_delims])
      FileMetadata.new(metadata, data)
    end

    def update_file(path, metadata: nil, data: nil, append_metadata: true, app: new_middleman)
      if metadata.nil? or data.nil? or append_metadata
        old_file_contents = parse_file(path)
        metadata          = old_file_contents.metadata.merge(metadata) if append_metadata and not metadata.nil?

        metadata ||= old_file_contents.metadata
        data     ||= old_file_contents.data
      end

      new_file_contents = metadata.to_yaml + app.config[:frontmatter_delims][:yaml][0][-1] + "\n" + data
      File.write(path, new_file_contents)
    end

    def new_middleman(mode: :build)
      ENV['MM_ROOT'] ||= middleman_root_dir
      Middleman::Application.new do
        config[:mode] = mode
      end
    end

    def middleman_root_dir
      FirstSetup.instance.save_local_dir
    end
  end
end