class AddMoreFieldsForLoanEstimateTemplate < ActiveRecord::Migration
  def change
    add_column :loans, :recording_fees_and_other_taxes, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :transfer_taxes, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :homeowners_insurance_premium, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :mortgage_insurance_premium, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :prepaid_interest_per_day, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :prepaid_property_taxes, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :homeowners_insurance_premium_months, :integer
    add_column :loans, :mortgage_insurance_premium_months, :integer
    add_column :loans, :prepaid_interest_days, :integer
    add_column :loans, :prepaid_property_taxes_months, :integer
    add_column :loans, :prepaid_interest_rate, :decimal, :precision => 9, :scale => 3, default: 0.000


  end
end
