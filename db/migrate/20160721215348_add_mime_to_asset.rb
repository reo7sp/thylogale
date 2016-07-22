class AddMimeToAsset < ActiveRecord::Migration[5.0]
  def change
    add_column :page_assets, :mime, :string
  end
end
