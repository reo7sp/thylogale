class PageFolder < ActiveRecord::Base
  has_many :pages, foreign_key: 'root_folder_id', dependent: :destroy
  has_many :subfolders, class_name: 'PageFolder', foreign_key: 'root_folder_id', dependent: :destroy
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: 'subfolders_count'

  validates_presence_of :name
  validates_format_of :name, with: /\A^[^\s~#%&*{}\\:<>?\/+|"]+\z/
  validates_presence_of :root_folder, unless: :is_root?
  validates_presence_of :path

  def is_root?
    id == 1
  end

  def self.root
    first
  end
end
