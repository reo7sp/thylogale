class Page < ActiveRecord::Base
  belongs_to :page_folder, touch: true, counter_cache: true, dependent: :destroy
end
