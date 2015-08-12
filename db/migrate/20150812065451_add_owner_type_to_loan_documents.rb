class AddOwnerTypeToLoanDocuments < ActiveRecord::Migration
  def change
    add_column :loan_documents, :owner_type, :string
  end
end
