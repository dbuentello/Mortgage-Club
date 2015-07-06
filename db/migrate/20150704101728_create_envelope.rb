class CreateEnvelope < ActiveRecord::Migration
  def change
    create_table :envelopes do |t|
      t.string :docusign_id
      t.integer :template_id
      t.integer :loan_id
    end

    rename_column :documents, :borrower_id, :owner_id
  end
end
