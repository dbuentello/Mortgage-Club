class RemoveOldDocumentModel < ActiveRecord::Migration
  def change
    drop_table :loan_documents
    drop_table :property_documents
    drop_table :borrower_documents
    drop_table :closing_documents
  end
end
