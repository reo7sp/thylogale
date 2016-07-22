class AddPageAssetCountToPage < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :page_assets_count, :integer
  end
end
