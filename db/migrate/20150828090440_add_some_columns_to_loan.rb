class AddSomeColumnsToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :include_property_taxes, :boolean
    add_column :loans, :include_homeowners_insurance, :boolean
    add_column :loans, :include_other, :boolean
    add_column :loans, :include_other_text, :boolean
    add_column :loans, :prepayment_penalty_text, :text
    add_column :loans, :balloon_payment_text, :text
    add_column :loans, :payment_calculation, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :estimated_loan_costs, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :estimated_other_costs, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :application_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :services_cannot_shop_total, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :flood_determination_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :flood_monitoring_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :tax_monitoring_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :tax_status_research_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :services_can_shop_total, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :pest_inspection_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :survey_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :insurance_binder, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :lenders_title_policy, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :settlement_agent_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :title_search, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :loan_costs_total, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :underwriting_fee, :decimal, :precision => 11, :scale => 2, default: 0.00
    add_column :loans, :points, :decimal, :precision => 9, :scale => 3, default: 0.000
    change_column :loans, :amount, :decimal, :precision => 11, :scale => 2, default: 0.00
  end
end
