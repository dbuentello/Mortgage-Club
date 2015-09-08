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
    add_column :loans, :initial_mortgage_insurance, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :initial_property_taxes_per_month, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :initial_property_taxes, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :initial_homeowner_insurance_months, :integer
    add_column :loans, :initial_mortgage_insurance_months, :integer
    add_column :loans, :initial_property_taxes_months, :integer
    add_column :loans, :owner_title_policy, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :closing_costs_financed, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :down_payment, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :deposit, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :funds_for_borrower, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :seller_credits, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :adjustments_and_other_credits, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :lender_nmls_id, :string
    add_column :loans, :loan_officer_name_1, :string
    add_column :loans, :loan_officer_nmls_id_1, :string
    add_column :loans, :loan_officer_email_1, :string
    add_column :loans, :loan_officer_phone_1, :string
    add_column :loans, :mortgage_broker_name, :string
    add_column :loans, :mortgage_broker_nmls_id, :string
    add_column :loans, :loan_officer_name_2, :string
    add_column :loans, :loan_officer_nmls_id_2, :string
    add_column :loans, :loan_officer_email_2, :string
    add_column :loans, :loan_officer_phone_2, :string
    add_column :loans, :in_5_years_total, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :in_5_years_principal, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :annual_percentage_rate, :decimal, :precision => 9, :scale => 3, default: 0.000
    add_column :loans, :total_interest_percentage, :decimal, :precision => 9, :scale => 3, default: 0.000
    add_column :loans, :assumption_will_allow, :boolean
    add_column :loans, :assumption_will_not_allow, :boolean
    add_column :loans, :late_days, :integer
    add_column :loans, :late_fee_text, :string
    add_column :loans, :servicing_service, :boolean
    add_column :loans, :servicing_transfer, :boolean
  end
end
