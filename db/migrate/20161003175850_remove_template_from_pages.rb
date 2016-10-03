class RemoveTemplateFromPages < ActiveRecord::Migration[5.0]
  def change
    remove_column :pages, :template, :string
  end
end
