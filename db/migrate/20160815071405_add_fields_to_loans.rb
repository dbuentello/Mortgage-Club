class AddFieldsToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :lender_underwriting_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :appraisal_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :tax_certification_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :flood_certification_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :outside_signing_service_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :concurrent_loan_charge_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :endorsement_charge_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :lender_title_policy_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :recording_service_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :settlement_agent_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :recording_fees, :decimal, precision: 13, scale: 3
    add_column :loans, :owner_title_policy_fee, :decimal, precision: 13, scale: 3
    add_column :loans, :prepaid_item_fee, :decimal, precision: 13, scale: 3
  end
end
