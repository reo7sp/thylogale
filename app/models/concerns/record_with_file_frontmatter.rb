module RecordWithFileFrontmatter
  extend ActiveSupport::Concern

  # this concern assumes that you has already included RecordWithFile concern

  included do
    @metadata_accessors_was_defined = false

    define_attribute_method 'metadata'
    before_save :save_data, if: "metadata_changed? and not data_changed?"
  end

  def metadata
    @parsed_file_contents ||= SiteBuilder.parse_file(abs_path)
    @metadata             ||= @parsed_file_contents.metadata
  end

  def data
    @parsed_file_contents ||= SiteBuilder.parse_file(abs_path)
    @data                 ||= @parsed_file_contents.data || ''
  end

  def respond_to_missing?(method, *)
    respond_to_metadata_accessor?(method) ? true : super
  end

  private

  def save_data
    run_callbacks :data_save do
      FileUtils.mkdir_p(File.dirname(abs_path))
      File.binwrite(abs_path, @data)
    end
  end

  def define_metadata_accessors
    metadata.keys.each do |key|
      define_attribute_method key

      define_singleton_method(key) do
        metadata[key]
      end

      define_singleton_method("#{key}=") do |value|
        send("#{key}_will_change!")
        metadata_will_change!
        metadata[key] = value
      end
    end

    @metadata_accessors_was_defined = true
  end

  def method_missing(method, *args)
    if name? and not @metadata_accessors_was_defined and metadata.key?(method.to_s.delete('='))
      define_metadata_accessors
      send(method, *args)
    else
      super
    end
  end

  def respond_to_metadata_accessor?(accessor)
    return false unless @metadata_accessors_was_defined
    metadata.key?(accessor.to_s.delete('='))
  rescue
    false
  end

end