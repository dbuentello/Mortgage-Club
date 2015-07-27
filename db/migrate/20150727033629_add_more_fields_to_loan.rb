class AddMoreFieldsToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :loan_amount_increase, :boolean
    add_column :loans, :interest_rate_increase, :boolean
    add_column :loans, :included_property_taxes, :boolean
    add_column :loans, :included_homeowners_insurance, :boolean
    add_column :loans, :included_other, :boolean
    add_column :loans, :included_other_text, :boolean
    add_column :loans, :in_escrow_property_taxes, :boolean
    add_column :loans, :in_escrow_homeowners_insurance, :boolean
    add_column :loans, :in_escrow_other, :boolean

    add_column :loans, :loan_costs, :decimal, :precision => 11, :scale => 2
    add_column :loans, :other_costs, :decimal, :precision => 11, :scale => 2
    add_column :loans, :lender_credits, :decimal, :precision => 11, :scale => 2
    add_column :loans, :estimated_cash_to_close, :decimal, :precision => 11, :scale => 2
    add_column :loans, :lender_name, :string
    add_column :loans, :fha_upfront_premium_amount, :decimal, :precision => 11, :scale => 2
    add_column :loans, :term_months, :integer
    add_column :loans, :lock_period, :integer
    add_column :loans, :margin, :decimal, :precision => 11, :scale => 2
    add_column :loans, :pmi_annual_premium_mount, :decimal, :precision => 11, :scale => 2
    add_column :loans, :pmi_monthly_premium_amount, :decimal, :precision => 11, :scale => 2
    add_column :loans, :pmi_monthly_premium_percent, :decimal, :precision => 11, :scale => 2
    add_column :loans, :pmi_required, :decimal, :precision => 11, :scale => 2
    add_column :loans, :apr, :decimal, :precision => 11, :scale => 2
    add_column :loans, :price, :decimal, :precision => 11, :scale => 2
    add_column :loans, :product_code, :string
    add_column :loans, :product_index, :integer
    add_column :loans, :total_margin_adjustment, :decimal, :precision => 11, :scale => 2
    add_column :loans, :total_price_adjustment, :decimal, :precision => 11, :scale => 2
    add_column :loans, :total_rate_adjustment, :decimal, :precision => 11, :scale => 2
    add_column :loans, :srp_adjustment, :decimal, :precision => 11, :scale => 2
  end
end
