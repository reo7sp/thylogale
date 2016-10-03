class RemoveS3FromFirstSetup < ActiveRecord::Migration[5.0]
  def change
    remove_column :first_setups, :save_choice, :string
    remove_column :first_setups, :save_s3_access_key, :string
    remove_column :first_setups, :save_s3_secret, :string
    remove_column :first_setups, :save_s3_region, :string
  end
end
