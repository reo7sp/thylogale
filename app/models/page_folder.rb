class PageFolder < ActiveRecord::Base
  has_many :pages, foreign_key: 'root_folder_id', dependent: :destroy
  has_many :subfolders, class_name: 'PageFolder', foreign_key: 'root_folder_id', dependent: :destroy
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: :subdirectories_count

  validates :name, presence: true
  validates :root_folder, presence: true, unless: :is_root?

  def is_root?
    id == 1
  end

  def self.root
    first
  end
end
