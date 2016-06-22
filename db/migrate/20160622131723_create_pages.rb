class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.string :template
      t.references :page_folder, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
