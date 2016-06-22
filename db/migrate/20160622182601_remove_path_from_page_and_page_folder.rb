class RemovePathFromPageAndPageFolder < ActiveRecord::Migration
  def change
    remove_column :pages, :path, :string
    remove_column :page_folders, :path, :string

    add_column :page_folders, :name, :string
    add_column :page_folders, :title, :string

    rename_column :pages, :slug, :name
  end
end
