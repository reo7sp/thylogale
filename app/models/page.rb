class Page < ActiveRecord::Base
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true, dependent: :destroy

  validates :name, presence: true
  validates :title, presence: true
  validates :root_folder, presence: true

  after_create { container_service.create }
  after_destroy { container_service.destroy }
  after_update :sync_update_with_container

  def container_service
    if @container_service.nil?
      case container
        when 'local'
          @container_service = LocalPageContainer.new(self, FirstSetup.instance)

        when 's3'
          @container_service = S3PageContainer.new(self, FirstSetup.instance)
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
