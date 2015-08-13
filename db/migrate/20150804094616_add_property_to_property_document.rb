class AddPropertyToPropertyDocument < ActiveRecord::Migration
  def change
    add_reference :property_documents, :property, index: true, foreign_key: true, type: :uuid
  end
end
