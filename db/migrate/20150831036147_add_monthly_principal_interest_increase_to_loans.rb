class AddMonthlyPrincipalInterestIncreaseToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :monthly_principal_interest_increase, :boolean
  end
end
