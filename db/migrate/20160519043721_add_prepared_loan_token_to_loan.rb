class AddPreparedLoanTokenToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :prepared_loan_token, :string
  end
end
