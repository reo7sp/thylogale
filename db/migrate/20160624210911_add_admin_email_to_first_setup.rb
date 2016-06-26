class AddAdminEmailToFirstSetup < ActiveRecord::Migration
  def change
    add_column :first_setups, :admin_email, :string
  end
end
