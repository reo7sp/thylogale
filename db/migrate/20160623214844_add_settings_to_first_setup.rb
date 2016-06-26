class AddSettingsToFirstSetup < ActiveRecord::Migration
  def change
    add_column :first_setups, :import_choice, :string
    add_column :first_setups, :save_choice, :string
    add_column :first_setups, :save_s3_access_key, :string
    add_column :first_setups, :save_s3_secret, :string
    add_column :first_setups, :save_s3_region, :string
    add_column :first_setups, :save_s3_bucket, :string
    add_column :first_setups, :admin_password, :string
  end
end
