module RecordWithFileFrontmatter
  extend ActiveSupport::Concern

  included do
    @metadata_accessors_was_defined = false
  end

  def metadata
    @parsed_file_contents ||= SiteBuilder.parse_file(abs_path)
    @metadata             ||= @parsed_file_contents.metadata
  end

  def data
    @parsed_file_contents ||= SiteBuilder.parse_file(abs_path)
    @data                 ||= @parsed_file_contents.data
  end

  def save_data
    SiteBuilder.update_file(abs_path, metadata: metadata, data: data, append_metadata: false)
  end

  def respond_to_missing?(method, *)
    metadata.key?(method.delete('=')) ? true : super
  end

  def method_missing(method, *args)
    if not @metadata_accessors_was_defined and metadata.key?(method.delete('='))
      define_metadata_accessors
      send(method, *args)
    else
      super
    end
  end

  private

  def define_metadata_accessors
    metadata.keys.each do |key|
      define_attribute_method key

      define_singleton_method(key) do
        metadata[key]
      end

      define_singleton_method("#{key}=") do |value|
        send("#{key}_will_change!")
        metadata[key] = value
      end
    end

    @metadata_accessors_was_defined = true
  end

end