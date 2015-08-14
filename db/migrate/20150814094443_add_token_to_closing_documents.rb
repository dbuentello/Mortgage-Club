class AddTokenToClosingDocuments < ActiveRecord::Migration
  def change
    add_column :closing_documents, :token, :string
  end
end
