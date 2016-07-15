class PageFolder < ActiveRecord::Base
  has_many :pages, foreign_key: 'root_folder_id', dependent: :destroy
  has_many :subfolders, class_name: 'PageFolder', foreign_key: 'root_folder_id', dependent: :destroy
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: 'subfolders_count'

  validates_presence_of :name
  validates_format_of :name, with: /\A^[^\s~#%&*{}\\:<>?\/+|"]+\z/, unless: :is_root?
  validates_length_of :name, minimum: 1

  validates_presence_of :root_folder, unless: :is_root?
  validates_presence_of :path
  validates_uniqueness_of :path

  validates_presence_of :default_template

  def is_root?
    id == 1
  end

  def self.root
    first
  end
end
