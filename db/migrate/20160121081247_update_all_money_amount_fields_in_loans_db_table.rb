class UpdateAllMoneyAmountFieldsInLoansDbTable < ActiveRecord::Migration
  def up
    change_column :loans, :amount, :decimal, precision: 13, scale: 2
    change_column :loans, :refinance, :decimal, precision: 13, scale: 2
    change_column :loans, :estimated_prepaid_items, :decimal, precision: 13, scale: 2
    change_column :loans, :estimated_closing_costs, :decimal, precision: 13, scale: 2
    change_column :loans, :pmi_mip_funding_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :borrower_closing_costs, :decimal, precision: 13, scale: 2
    change_column :loans, :other_credits, :decimal, precision: 13, scale: 2
    change_column :loans, :pmi_mip_funding_fee_financed, :decimal, precision: 13, scale: 2

    change_column :loans, :monthly_payment, :decimal, precision: 13, scale: 2
    change_column :loans, :prepayment_penalty_amount, :decimal, precision: 13, scale: 2
    change_column :loans, :pmi, :decimal, precision: 13, scale: 2

    change_column :loans, :loan_costs, :decimal, precision: 13, scale: 2
    change_column :loans, :other_costs, :decimal, precision: 13, scale: 2
    change_column :loans, :lender_credits, :decimal, precision: 13, scale: 2
    change_column :loans, :estimated_cash_to_close, :decimal, precision: 13, scale: 2
    change_column :loans, :fha_upfront_premium_amount, :decimal, precision: 13, scale: 2
    change_column :loans, :margin, :decimal, precision: 13, scale: 2
    change_column :loans, :pmi_annual_premium_mount, :decimal, precision: 13, scale: 2
    change_column :loans, :pmi_monthly_premium_amount, :decimal, precision: 13, scale: 2
    change_column :loans, :pmi_monthly_premium_percent, :decimal, precision: 13, scale: 4
    change_column :loans, :apr, :decimal, precision: 13, scale: 3

    change_column :loans, :price, :decimal, precision: 13, scale: 3
    change_column :loans, :total_margin_adjustment, :decimal, precision: 13, scale: 2
    change_column :loans, :total_price_adjustment, :decimal, precision: 13, scale: 2
    change_column :loans, :total_rate_adjustment, :decimal, precision: 13, scale: 2
    change_column :loans, :srp_adjustment, :decimal, precision: 13, scale: 2
    change_column :loans, :appraisal_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :city_county_deed_stamp_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :credit_report_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :document_preparation_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :flood_certification, :decimal, precision: 13, scale: 2
    change_column :loans, :settlement_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :state_deed_tax_stamp_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :tax_related_service_fee, :decimal, precision: 13, scale: 2
    change_column :loans, :title_insurance_fee, :decimal, precision: 13, scale: 2

    change_column :loans, :estimated_loan_costs, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :estimated_other_costs, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :application_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :flood_determination_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :flood_monitoring_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :tax_monitoring_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :tax_status_research_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :pest_inspection_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :survey_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :insurance_binder, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :lenders_title_policy, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :settlement_agent_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :title_search, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :underwriting_fee, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :recording_fees_and_other_taxes, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :transfer_taxes, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :homeowners_insurance_premium, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :mortgage_insurance_premium, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :prepaid_interest_per_day, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :prepaid_property_taxes, :decimal, precision: 13, scale: 2, default: 0.0

    change_column :loans, :initial_mortgage_insurance, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :initial_property_taxes_per_month, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :initial_property_taxes, :decimal, precision: 13, scale: 2, default: 0.0

    change_column :loans, :owner_title_policy, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :closing_costs_financed, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :down_payment, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :deposit, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :funds_for_borrower, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :seller_credits, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :adjustments_and_other_credits, :decimal, precision: 13, scale: 2, default: 0.0

    change_column :loans, :in_5_years_total, :decimal, precision: 13, scale: 2, default: 0.0
    change_column :loans, :in_5_years_principal, :decimal, precision: 13, scale: 2, default: 0.0
  end

  def down
    change_column :loans, :amount, :decimal, precision: 11, scale: 2
    change_column :loans, :refinance, :decimal, precision: 11, scale: 2
    change_column :loans, :estimated_prepaid_items, :decimal, precision: 11, scale: 2
    change_column :loans, :estimated_closing_costs, :decimal, precision: 11, scale: 2
    change_column :loans, :pmi_mip_funding_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :borrower_closing_costs, :decimal, precision: 11, scale: 2
    change_column :loans, :other_credits, :decimal, precision: 11, scale: 2
    change_column :loans, :pmi_mip_funding_fee_financed, :decimal, precision: 11, scale: 2

    change_column :loans, :monthly_payment, :decimal, precision: 11, scale: 2
    change_column :loans, :prepayment_penalty_amount, :decimal, precision: 11, scale: 2
    change_column :loans, :pmi, :decimal, precision: 11, scale: 2

    change_column :loans, :loan_costs, :decimal, precision: 11, scale: 2
    change_column :loans, :other_costs, :decimal, precision: 11, scale: 2
    change_column :loans, :lender_credits, :decimal, precision: 11, scale: 2
    change_column :loans, :estimated_cash_to_close, :decimal, precision: 11, scale: 2
    change_column :loans, :fha_upfront_premium_amount, :decimal, precision: 11, scale: 2
    change_column :loans, :margin, :decimal, precision: 11, scale: 2
    change_column :loans, :pmi_annual_premium_mount, :decimal, precision: 11, scale: 2
    change_column :loans, :pmi_monthly_premium_amount, :decimal, precision: 11, scale: 2
    change_column :loans, :pmi_monthly_premium_percent, :decimal, precision: 11, scale: 4
    change_column :loans, :apr, :decimal, precision: 11, scale: 3

    change_column :loans, :price, :decimal, precision: 11, scale: 3
    change_column :loans, :total_margin_adjustment, :decimal, precision: 11, scale: 2
    change_column :loans, :total_price_adjustment, :decimal, precision: 11, scale: 2
    change_column :loans, :total_rate_adjustment, :decimal, precision: 11, scale: 2
    change_column :loans, :srp_adjustment, :decimal, precision: 11, scale: 2
    change_column :loans, :appraisal_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :city_county_deed_stamp_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :credit_report_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :document_preparation_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :flood_certification, :decimal, precision: 11, scale: 2
    change_column :loans, :settlement_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :state_deed_tax_stamp_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :tax_related_service_fee, :decimal, precision: 11, scale: 2
    change_column :loans, :title_insurance_fee, :decimal, precision: 11, scale: 2

    change_column :loans, :estimated_loan_costs, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :estimated_other_costs, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :application_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :flood_determination_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :flood_monitoring_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :tax_monitoring_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :tax_status_research_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :pest_inspection_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :survey_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :insurance_binder, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :lenders_title_policy, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :settlement_agent_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :title_search, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :underwriting_fee, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :recording_fees_and_other_taxes, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :transfer_taxes, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :homeowners_insurance_premium, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :mortgage_insurance_premium, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :prepaid_interest_per_day, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :prepaid_property_taxes, :decimal, precision: 11, scale: 2, default: 0.0

    change_column :loans, :initial_mortgage_insurance, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :initial_property_taxes_per_month, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :initial_property_taxes, :decimal, precision: 11, scale: 2, default: 0.0

    change_column :loans, :owner_title_policy, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :closing_costs_financed, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :down_payment, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :deposit, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :funds_for_borrower, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :seller_credits, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :adjustments_and_other_credits, :decimal, precision: 11, scale: 2, default: 0.0

    change_column :loans, :in_5_years_total, :decimal, precision: 11, scale: 2, default: 0.0
    change_column :loans, :in_5_years_principal, :decimal, precision: 11, scale: 2, default: 0.0
  end
end
