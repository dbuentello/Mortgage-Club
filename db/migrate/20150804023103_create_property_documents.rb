class CreatePropertyDocuments < ActiveRecord::Migration
  def change
    create_table :property_documents do |t|
      t.string :type
      t.integer :owner_id

      t.string :description
      t.timestamps
    end

    add_attachment :property_documents, :attachment
    add_index :property_documents, :owner_id
  end
end
