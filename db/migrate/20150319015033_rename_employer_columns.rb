class RenameEmployerColumns < ActiveRecord::Migration
  def change
    rename_column :borrower_employers, :employment_contact_name, :employer_contact_name
    rename_column :borrower_employers, :employment_contact_number, :employer_contact_number
    rename_column :borrower_employers, :months_at_employment, :months_at_employer
    rename_column :borrower_employers, :years_at_employment, :years_at_employer
  end
end
