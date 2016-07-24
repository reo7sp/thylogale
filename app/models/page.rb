class Page < ActiveRecord::Base
  include RecordWithFileContainer

  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true
  has_many :page_assets, dependent: :destroy

  validates_presence_of :name, :title, :root_folder, :template, :path
  validates_uniqueness_of :path

  before_save :apply_template, if: :data_changed?

  def template_instance
    Thylogale::SiteConfigs.templates[template]
  end

  def template_instance=(template)
    self.template = template.name
  end

  private

  def apply_template
    template_instance.process
  end
end
