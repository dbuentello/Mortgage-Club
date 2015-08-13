class CreatePropertyDocuments < ActiveRecord::Migration
  def change
    create_table :property_documents, id: :uuid do |t|
      t.string  :type
      t.uuid    :owner_id

      t.string  :description
      t.timestamps null: false
    end

    add_attachment :property_documents, :attachment
    add_index :property_documents, :owner_id
  end
end
