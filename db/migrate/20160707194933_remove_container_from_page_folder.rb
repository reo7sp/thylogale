class RemoveContainerFromPageFolder < ActiveRecord::Migration
  def change
    remove_column :page_folders, :container, :string
    remove_column :pages, :container, :string
    remove_column :first_setups, :import_choice
    rename_column :page_folders, :subdirectories_count, :subfolders_count
  end
end
