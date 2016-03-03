class AddMoreFieldsToLoanMember < ActiveRecord::Migration
  def change
    add_column :loan_members, :company_name, :string
    add_column :loan_members, :company_address, :string
    add_column :loan_members, :company_phone_number, :string
    add_column :loan_members, :company_nmls, :string

  end
end
