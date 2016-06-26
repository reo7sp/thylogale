class RemoveSaveS3BucketFromFirstSetup < ActiveRecord::Migration
  def change
    remove_column :first_setups, :save_s3_bucket, :string
  end
end
