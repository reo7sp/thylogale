class SetReferencesBetweenPageFolders < ActiveRecord::Migration
  def change
    add_column :page_folders, :pages_count, :integer
    add_reference :page_folders, :root_folder, index: true
  end
end
