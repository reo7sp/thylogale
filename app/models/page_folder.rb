class PageFolder < ActiveRecord::Base
  has_many :pages
  has_many :subfolders, class_name: 'PageFolder', foreign_key: 'root_folder_id'
  belongs_to :root_folder, class_name: 'PageFolder'

  validates :name, presence: true
  validates :root_folder, presence: true, unless: :is_root?

  def is_root?
    id == 1
  end
end
