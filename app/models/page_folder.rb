class PageFolder < ApplicationRecord
  include PgSearch

  has_many :pages, foreign_key: 'root_folder_id', dependent: :destroy
  has_many :subfolders, class_name: 'PageFolder', foreign_key: 'root_folder_id', dependent: :destroy
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: 'subfolders_count'

  validates_presence_of :name
  validates_format_of :name, with: /\A^[^\s~#%&*{}\\:<>?\/+|"]+\z/, unless: :root?

  validates_presence_of :root_folder, unless: :root?
  validates_presence_of :path
  validates_uniqueness_of :path
  validate do
    unless (root? and path == '') or (root_folder.root? and not path.include?('/') == 1) or File.dirname(path) == root_folder.path
      errors.add(:page, 'does not belongs to root folder')
    end
  end

  pg_search_scope :search_by_title, against: :title

  def root?
    id == 1
  end

  def abs_path
    if root?
      File.join(FirstSetup.instance.save_local_dir, 'source')
    else
      File.join(FirstSetup.instance.save_local_dir, 'source', path)
    end
  end

  def abs_build_path
    if root?
      File.join(FirstSetup.instance.save_local_dir, 'build')
    else
      File.join(FirstSetup.instance.save_local_dir, 'build', path)
    end
  end

  class << self
    def root
      first
    end
  end
end
