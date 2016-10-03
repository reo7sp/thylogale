module SiteBuilder
  class << self
    def set_file_metadata(path, metadata, append: true, app: new_middleman)
      old_metadata, text = Middleman::Util::Data::parse(path, app.config[:frontmatter_delims])
      metadata = old_metadata.merge(metadata) if append
      new_file_contents = metadata.to_yaml + app.config[:frontmatter_delims][:yaml][-1] + "\n" + text
      File.write(path, new_file_contents)
    end

    def get_file_metadata(path, app: new_middleman)
      Middleman::Util::Data::parse(path, app.config[:frontmatter_delims]).first
    end

    def build(app: new_middleman)
      builder = Middleman::Builder.new(app)
      builder.run!
    end

    def new_middleman(mode: :build)
      ENV['MM_ROOT'] ||= FirstSetup.instance.save_local_dir
      Middleman::Application.new do
        config[:mode] = mode
      end
    end
  end
end