class Page < ActiveRecord::Base
  belongs_to :root_folder, class_name: 'PageFolder', touch: true, counter_cache: true, dependent: :destroy

  validates :name, presence: true
  validates :title, presence: true
  validates :root_folder, presence: true
end
