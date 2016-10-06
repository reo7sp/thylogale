class RemoveNameFromPageAsset < ActiveRecord::Migration[5.0]
  def change
    remove_column :page_assets, :name, :string
  end
end
