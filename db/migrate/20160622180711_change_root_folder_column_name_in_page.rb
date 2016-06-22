class ChangeRootFolderColumnNameInPage < ActiveRecord::Migration
  def change
    rename_column :page, :page_folder_id, :root_folder_id
  end
end
