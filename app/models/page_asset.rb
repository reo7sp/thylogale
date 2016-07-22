class PageAsset < ActiveRecord::Base
  include RecordWithFileContainer

  belongs_to :page, touch: true, counter_cache: true

  validates_presence_of :name, :mime, :page
  validates_format_of :name, with: /\A.+\..+\z/
  validates_format_of :mime, with: /\A.+\/.+\z/

  def path
    "#{page_id}/#{name}"
  end

  def path_was
    "#{page_id_was}/#{name_was}"
  end

  def path_changed?
    page_id_changed? or name_changed?
  end
end
