class MortgageData < ActiveRecord::Base
  self.per_page = 5

  PERMITTED_ATTRS = [:property_address,
                     :owner_name_1,
                     :owner_name_2,
                     :original_purchase_price,
                     :original_loan_date,
                     :original_loan_amount,
                     :original_terms,
                     :original_lock_in_date,
                     :avg_rate_at_lock_in_date,
                     :original_lender_name,
                     :original_lender_average_overlay,
                     :original_estimated_interest_rate,
                     :date_of_proposal,
                     :original_estimated_mortgage_balance,
                     :original_monthly_payment,
                     :original_estimated_home_value,
                     :lower_rate_loan_amount,
                     :lower_rate_interest_rate,
                     :lower_rate_loan_start_date,
                     :lower_rate_estimated_closing_costs,
                     :lower_rate_lender_credit,
                     :lower_rate_net_closing_costs,
                     :lower_rate_new_monthly_payment,
                     :lower_rate_savings_1year,
                     :lower_rate_savings_3year,
                     :lower_rate_savings_10year,
                     :cash_out_ltv,
                     :cash_out_loan_amount,
                     :cash_out_cash_amount,
                     :cash_out_interest_rate,
                     :cash_out_loan_start_date,
                     :cash_out_estimated_closing_costs,
                     :cash_out_lender_credit,
                     :cash_out_net_closing_costs,
                     :cash_out_new_monthly_payment
                    ]

  def self.search(search)
    where("property_address ILIKE ? OR owner_name_1 ILIKE ? OR owner_name_2 ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
