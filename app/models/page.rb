class Page < ActiveRecord::Base
  include RecordWithFileContainer
  include PgSearch

  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true
  has_many :page_assets, dependent: :destroy

  validates_presence_of :name, :title, :root_folder, :template, :path
  validates_uniqueness_of :path

  before_save :apply_template_on_save, if: :data_changed?

  pg_search_scope :search_by_title, against: :title

  def template_instance
    @template_instance ||= Thylogale::Templates.templates[template]
  end

  def template_instance=(template_instance)
    @template_instance = template_instance
    self.template      = template_instance.name
  end

  def publish
    contents = template_instance.process_publish(self)
    file_container = Thylogale.file_container('published', path)
    file_container.write(contents)
  end

  private

  def apply_template_on_save
    self.data = template_instance.process_save(self)
  end
end
