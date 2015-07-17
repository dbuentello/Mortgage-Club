class CreatePendingBorrower < ActiveRecord::Migration
  def change
    create_table :pending_borrowers do |t|
      t.string :name
      t.string :email
      t.integer :loan_id
      t.string :timestamps
    end

    add_index :pending_borrowers, :loan_id
  end
end
