class CreateNewDesignedDocuments < ActiveRecord::Migration
  def change
    create_table :documents, id: :uuid do |t|
      t.string  :document_type
      t.string  :subjectable_type
      t.uuid    :subjectable_id
      t.string  :description
      t.string  :original_filename
      t.string  :token
      t.references :user, index: true, foreign_key: true, type: :uuid
      t.timestamps null: false
    end

    add_attachment :documents, :attachment
    add_index :documents, :subjectable_id
    add_index :documents, :subjectable_type
    add_index :documents, :document_type
  end
end
