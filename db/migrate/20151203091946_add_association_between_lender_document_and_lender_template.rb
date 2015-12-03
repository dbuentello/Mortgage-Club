class AddAssociationBetweenLenderDocumentAndLenderTemplate < ActiveRecord::Migration
  def change
    add_reference :lender_documents, :lender_template, index: true, foreign_key: true, type: :uuid
  end
end
