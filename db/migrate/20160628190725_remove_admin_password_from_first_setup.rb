class RemoveAdminPasswordFromFirstSetup < ActiveRecord::Migration
  def change
    remove_column :first_setups, :admin_password, :string
    remove_column :first_setups, :admin_email, :string
  end
end
