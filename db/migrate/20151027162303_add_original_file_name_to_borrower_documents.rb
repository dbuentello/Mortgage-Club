class AddOriginalFileNameToBorrowerDocuments < ActiveRecord::Migration
  def change
    add_column :borrower_documents, :original_filename, :string
  end
end
