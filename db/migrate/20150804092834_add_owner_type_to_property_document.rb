class AddOwnerTypeToPropertyDocument < ActiveRecord::Migration
  def change
    add_column :property_documents, :owner_type, :string
  end
end
