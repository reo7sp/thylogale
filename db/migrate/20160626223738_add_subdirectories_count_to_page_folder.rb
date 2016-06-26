class AddSubdirectoriesCountToPageFolder < ActiveRecord::Migration
  def change
    add_column :page_folders, :subdirectories_count, :integer
  end
end
