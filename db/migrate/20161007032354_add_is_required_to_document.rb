class AddIsRequiredToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :is_required, :boolean
  end
end
