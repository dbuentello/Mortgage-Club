class AddEncryptionToBorrower < ActiveRecord::Migration
  def change
    add_column :borrowers, :encrypted_ssn, :string
    add_column :borrowers, :encrypted_ssn_iv, :string
    add_column :borrowers, :encrypted_dob, :string
    add_column :borrowers, :encrypted_dob_iv, :string
  end
end
