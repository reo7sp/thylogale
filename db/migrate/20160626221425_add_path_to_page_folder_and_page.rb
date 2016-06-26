class AddPathToPageFolderAndPage < ActiveRecord::Migration
  def change
    add_column :page_folders, :path, :string
    add_column :page_folders, :container, :string
    add_column :pages, :path, :string
    add_column :pages, :container, :string
  end
end
