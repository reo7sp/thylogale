class PageFolder < ApplicationRecord
  include PgSearch

  has_many :pages, foreign_key: 'root_folder_id', dependent: :destroy
  has_many :subfolders, class_name: 'PageFolder', foreign_key: 'root_folder_id', dependent: :destroy
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: 'subfolders_count'

  validates_presence_of :name
  validates_format_of :name, with: /\A^[^\s~#%&*{}\\:<>?\/+|"]+\z/, unless: :is_root?

  validates_presence_of :root_folder, unless: :is_root?
  validates_presence_of :path
  validates_uniqueness_of :path

  pg_search_scope :search_by_title, against: :title

  def is_root?
    id == 1
  end

  def abs_path
    if is_root?
      File.join(FirstSetup.instance.save_local_dir, 'source')
    else
      File.join(FirstSetup.instance.save_local_dir, 'source', path)
    end
  end

  class << self
    def root
      first
    end
  end
end
