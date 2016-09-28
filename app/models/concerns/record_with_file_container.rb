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

  def file_container
    raise NotImplementedError
  end

  def data
    @data ||= file_container.read rescue ''
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
    file_container.destroy
  end

  def move_data
    new_file_container_for(path_was).move(path)
  end

  def save_data
    file_container.write(@data)
  end
end