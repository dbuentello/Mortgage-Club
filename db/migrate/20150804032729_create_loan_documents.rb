class CreateLoanDocuments < ActiveRecord::Migration
  def change
    create_table :loan_documents do |t|
      t.string :type
      t.integer :owner_id

      t.string :description
      t.timestamps
    end

    add_attachment :loan_documents, :attachment
    add_index :loan_documents, :owner_id
  end
end
