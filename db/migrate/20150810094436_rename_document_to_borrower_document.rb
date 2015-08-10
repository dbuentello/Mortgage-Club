class RenameDocumentToBorrowerDocument < ActiveRecord::Migration
  def change
    rename_table :documents, :borrower_documents

    add_column :borrower_documents, :owner_type, :string
    add_reference :borrower_documents, :borrower, index: true, foreign_key: true
  end
end
