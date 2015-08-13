class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :type
      t.uuid   :borrower_id
    end

    add_attachment :documents, :attachment
    add_index :documents, :borrower_id
  end
end
