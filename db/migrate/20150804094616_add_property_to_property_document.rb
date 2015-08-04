class AddPropertyToPropertyDocument < ActiveRecord::Migration
  def change
    add_reference :property_documents, :property, index: true, foreign_key: true
  end
end
