class ChangeLoans < ActiveRecord::Migration
  def change
    remove_column :loans, :property_id
    remove_column :loans, :borrower_id
    remove_column :loans, :secondary_borrower_id
    
    add_column :borrowers, :loan_id, :integer
    add_column :properties, :loan_id, :integer

    add_index :borrowers, :loan_id
    add_index :properties, :loan_id
    
    remove_column :borrower_employers, :employer_address_id
    remove_column :borrower_addresses, :address_id
    remove_column :properties, :address_id

    add_column :addresses, :property_id, :integer
    add_column :addresses, :borrower_address_id, :integer
    add_column :addresses, :borrower_employer_id, :integer

    add_index :addresses, :property_id
    add_index :addresses, :borrower_address_id
    add_index :addresses, :borrower_employer_id
  end
end
