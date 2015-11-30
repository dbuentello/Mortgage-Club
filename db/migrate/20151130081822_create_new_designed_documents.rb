class CreateNewDesignedDocuments < ActiveRecord::Migration
  def change
    create_table :documents, id: :uuid do |t|
      t.string  :document_type
      t.string  :subject_type
      t.uuid    :subject_id
      t.string  :description
      t.string  :original_filename
      t.string  :token
      t.references :user, index: true, foreign_key: true, type: :uuid
      t.timestamps null: false
    end

    add_attachment :documents, :attachment
    add_index :documents, :subject_id
    add_index :documents, :subject_type
    add_index :documents, :document_type
  end
end
