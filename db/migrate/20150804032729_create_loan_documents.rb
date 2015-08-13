class CreateLoanDocuments < ActiveRecord::Migration
  def change
    create_table :loan_documents, id: :uuid do |t|
      t.string  :type
      t.uuid    :owner_id

      t.string  :description
      t.timestamps null: false
    end

    add_attachment :loan_documents, :attachment
    add_index :loan_documents, :owner_id

    add_column :loan_documents, :token, :string
    add_column :property_documents, :token, :string
  end
end
