class CreateFirstSetups < ActiveRecord::Migration
  def change
    create_table :first_setups do |t|
      t.column :done, :boolean

      t.timestamps null: false
    end
  end
end
