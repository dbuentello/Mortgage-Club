class AddFieldsToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :agency_case_number, :string
    add_column :loans, :lender_case_number, :string
    add_column :loans, :amount, :decimal, :precision => 11, :scale => 2
    add_column :loans, :interest_rate, :decimal, :precision => 11, :scale => 2
    add_column :loans, :num_of_months, :integer
    add_column :loans, :amortization_type, :string
    add_column :loans, :rate_lock, :boolean
    add_column :loans, :refinance, :decimal, :precision => 11, :scale => 2
    add_column :loans, :estimated_prepaid_items, :decimal, :precision => 11, :scale => 2
    add_column :loans, :estimated_closing_costs, :decimal, :precision => 11, :scale => 2
    add_column :loans, :pmi_mip_funding_fee, :decimal, :precision => 11, :scale => 2
    add_column :loans, :borrower_closing_costs, :decimal, :precision => 11, :scale => 2
    add_column :loans, :other_credits, :decimal, :precision => 11, :scale => 2
    add_column :loans, :other_credits_explain, :string
    add_column :loans, :pmi_mip_funding_fee_financed, :decimal, :precision => 11, :scale => 2
  end
end
