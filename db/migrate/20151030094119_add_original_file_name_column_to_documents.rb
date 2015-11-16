class AddOriginalFileNameColumnToDocuments < ActiveRecord::Migration
  def change
    add_column :closing_documents, :original_filename, :string
    add_column :loan_documents, :original_filename, :string
    add_column :property_documents, :original_filename, :string
  end
end
