class AddPrepaidHomeownersInsuranceToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :prepaid_homeowners_insurance, :decimal, precision: 13, scale: 3
  end
end
