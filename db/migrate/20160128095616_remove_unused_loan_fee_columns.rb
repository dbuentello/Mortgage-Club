class RemoveUnusedLoanFeeColumns < ActiveRecord::Migration
  def change
    remove_column :loans, :appraisal_fee
    remove_column :loans, :credit_report_fee
    remove_column :loans, :application_fee
    remove_column :loans, :underwriting_fee
    remove_column :loans, :flood_determination_fee
    remove_column :loans, :flood_monitoring_fee
    remove_column :loans, :tax_monitoring_fee
    remove_column :loans, :tax_status_research_fee
    remove_column :loans, :pest_inspection_fee
    remove_column :loans, :survey_fee
    remove_column :loans, :insurance_binder
    remove_column :loans, :lenders_title_policy
    remove_column :loans, :settlement_agent_fee
    remove_column :loans, :title_search
    remove_column :loans, :recording_fees_and_other_taxes
    remove_column :loans, :transfer_taxes
  end
end
