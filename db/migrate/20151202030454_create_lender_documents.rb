class CreateLenderDocuments < ActiveRecord::Migration
  def change
    create_table :lender_documents, id: :uuid do |t|
      t.string  :description
      t.string  :token
      t.references :user, index: true, foreign_key: true, type: :uuid
      t.references :loan, index: true, foreign_key: true, type: :uuid
      t.timestamps null: false
    end

    add_attachment :lender_documents, :attachment
  end
end
