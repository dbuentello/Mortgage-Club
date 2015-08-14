class CreateClosingDocuments < ActiveRecord::Migration
  def change
    create_table :closing_documents, id: :uuid do |t|
      t.string  :type
      t.string  :owner_type
      t.uuid    :owner_id
      t.string  :description
      t.references :closing, index: true, foreign_key: true, type: :uuid
      t.timestamps null: false
    end

    add_attachment :closing_documents, :attachment
    add_index :closing_documents, :owner_id
  end
end
