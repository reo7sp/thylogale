class AddSaveLocalDirToFirstSetup < ActiveRecord::Migration
  def change
    add_column :first_setups, :save_local_dir, :string
  end
end
