class AddEmailSettingsToFirstSetup < ActiveRecord::Migration
  def change
    add_column :first_setups, :email_choice, :string
    add_column :first_setups, :email_mailgun_api_key, :string
    add_column :first_setups, :email_mailgun_domain, :string
  end
end
