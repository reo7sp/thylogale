module SiteBuilder
  class << self
    FileMetadata = Struct.new(:metadata, :data)

    def build(app: new_middleman)
      load_site_gemfile unless @gemfile_loaded
      builder = Middleman::Builder.new(app)
      builder.run!
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

    private

    def load_site_gemfile
      gemfile = File.join(FirstSetup.instance.save_local_dir, 'Gemfile')
      lockfile = gemfile + '.lock'
      definition = Bundler::Definition.build(gemfile, lockfile, {})
      runtime = Bundler::Runtime.new(FirstSetup.instance.save_local_dir, definition)
      runtime.require
      @gemfile_loaded = true
    end

    def new_middleman(mode: :build)
      ENV['MM_ROOT'] ||= FirstSetup.instance.save_local_dir
      Middleman::Application.new do
        config[:mode] = mode
      end
    end
  end
end