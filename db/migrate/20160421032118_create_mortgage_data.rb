class CreateMortgageDataTable < ActiveRecord::Migration
  def change
    create_table :mortgage_data, id: :uuid do |t|
      t.string :property_address, index: true
      t.string :owner_name_1
      t.string :owner_name_2
      t.decimal :original_purchase_price, precision: 13, scale: 2
      t.date :original_loan_date
      t.decimal :original_loan_amount, precision: 13, scale: 2
      t.string :original_terms
      t.date :original_lock_in_date
      t.date :avg_rate_at_lock_in_date
      t.string :original_lender_name
      t.float :original_lender_average_overlay
      t.float :original_estimated_interest_rate
      t.date :date_of_proposal
      t.decimal :original_estimated_mortgage_balance, precision: 13, scale: 2
      t.decimal :original_monthly_payment, precision: 13, scale: 2
      t.decimal :original_estimated_home_value, precision: 13, scale: 2

      t.decimal :lower_rate_loan_amount, precision: 13, scale: 2
      t.float :lower_rate_interest_rate
      t.date :lower_rate_loan_start_date
      t.decimal :lower_rate_estimated_closing_costs, precision: 13, scale: 2
      t.decimal :lower_rate_lender_credit, precision: 13, scale: 2
      t.decimal :lower_rate_net_closing_costs, precision: 13, scale: 2
      t.decimal :lower_rate_new_monthly_payment, precision: 13, scale: 2
      t.decimal :lower_rate_savings_1year, precision: 13, scale: 2
      t.decimal :lower_rate_savings_3year, precision: 13, scale: 2
      t.decimal :lower_rate_savings_10year, precision: 13, scale: 2

      t.float :cash_out_ltv
      t.decimal :cash_out_loan_amount, precision: 13, scale: 2
      t.decimal :cash_out_cash_amount, precision: 13, scale: 2
      t.float :cash_out_interest_rate
      t.date :cash_out_loan_start_date
      t.decimal :cash_out_estimated_closing_costs, precision: 13, scale: 2
      t.decimal :cash_out_lender_credit, precision: 13, scale: 2
      t.decimal :cash_out_net_closing_costs, precision: 13, scale: 2
      t.decimal :cash_out_new_monthly_payment, precision: 13, scale: 2

      t.timestamps null:  false
    end
  end
end
