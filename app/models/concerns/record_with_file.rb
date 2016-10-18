module RecordWithFile
  extend ActiveSupport::Concern

  included do
    define_attribute_method 'data'
    define_model_callbacks :data_save

    after_destroy :delete_data
    after_update :move_data, if: :path_changed?
    after_save :save_data, if: :data_changed?
  end

  def root_abs_path
    PageFolder.root.abs_path
  end

  def abs_path
    File.join(root_abs_path, path)
  end

  def abs_path_was
    File.join(root_abs_path, path_was)
  end

  def data
    @data ||= File.binread(abs_path) rescue ''
  end

  def data=(data)
    @data ||= ''
    data_will_change!
    if data.respond_to?(:read)
      @data = data.read
    else
      @data = data
    end
  end

  private

  def delete_data
    File.delete(abs_path)
  end

  def move_data
    File.new(abs_path_was).move(abs_path)
  end

  def save_data
    run_callbacks :data_save do
      FileUtils.mkdir_p(File.dirname(abs_path))
      File.binwrite(abs_path, @data)
    end
  end
end