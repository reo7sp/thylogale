module RecordWithFileContainer
  extend ActiveSupport::Concern

  included do
    attribute :data, :string

    after_destroy :delete_data
    after_update :move_data, if: :path_changed?
    after_save :save_data, if: :data_changed?
  end

  def container_service_root
    self.class.name.demodulize.underscore.pluralize
  end

  def container_service
    @container_service ||= Thylogale.file_container(container_service_root, path)
  end

  def data
    @data ||= container_service.read rescue ''
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
    container_service.destroy
  end

  def move_data
    Thylogale.file_container(container_service_root, path_was).move(path)
  end

  def save_data
    container_service.write(@data)
  end
end