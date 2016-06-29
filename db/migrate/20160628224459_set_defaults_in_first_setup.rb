class SetDefaultsInFirstSetup < ActiveRecord::Migration
  def change
    change_column_default :first_setups, :done, false
  end
end
