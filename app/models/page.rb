class Page < ActiveRecord::Base
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true

  validates_presence_of :name, :title, :root_folder, :template
  validates_uniqueness_of :path

  after_create { container_service.create }
  after_destroy { container_service.destroy }
  after_update :sync_update_with_container

  def container_service
    @container_service ||= Thylogale.file_container('pages', path)
  end

  def data
    container_service.read
  end

  def data=(data)
    container_service.write(data)
  end

  private

  def sync_update_with_container
    # TODO
  end
end
