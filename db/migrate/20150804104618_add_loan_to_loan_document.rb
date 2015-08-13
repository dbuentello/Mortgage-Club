class AddLoanToLoanDocument < ActiveRecord::Migration
  def change
    add_reference :loan_documents, :loan, index: true, foreign_key: true, type: :uuid
  end
end
