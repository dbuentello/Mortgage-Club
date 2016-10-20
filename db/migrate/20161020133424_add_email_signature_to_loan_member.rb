class AddEmailSignatureToLoanMember < ActiveRecord::Migration
  def change
    add_column :loan_members, :email_signature, :text
  end
end
