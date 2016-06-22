class CreatePageFolders < ActiveRecord::Migration
  def change
    create_table :page_folders do |t|
      t.string :path

      t.timestamps null: false
    end
  end
end
