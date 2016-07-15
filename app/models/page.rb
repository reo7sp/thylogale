class Page < ActiveRecord::Base
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true
  has_one :template

  validates_presence_of :name, :title, :root_folder, :template
  validates_uniqueness_of :path

  after_create { container_service.create }
  after_destroy { container_service.destroy }
  after_update :sync_update_with_container

  def container_service
    if @container_service.nil?
      setup = FirstSetup.instance
      case setup.save_choice
        when 'local'
          @container_service = LocalPageContainer.new(self, setup)
        when 's3'
          @container_service = S3PageContainer.new(self, setup)
      end
    end
    @container_service
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
