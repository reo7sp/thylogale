class AddSiteDomainToFirstSetup < ActiveRecord::Migration
  def change
    add_column :first_setups, :site_domain, :string
  end
end
