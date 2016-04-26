FactoryGirl.define do
  factory :mortgage_data do |f|
    f.property_address { Faker::Address.street_address }
    f.owner_name_1 { Faker::Name.first_name + Faker::Name.last_name }
    f.owner_name_2 { Faker::Name.first_name + Faker::Name.last_name }
    f.original_purchase_price { Faker::Number.decimal(6, 2) }
    f.original_loan_date { Faker::Date.between(2.year.ago, 1.year.ago) }
    f.original_loan_amount { Faker::Number.decimal(6, 2) }
    f.original_terms { ["30 year fixed", "15 year fixed", "7/1 apr"].sample }
    f.original_lock_in_date { Faker::Date.between(3.year.ago, 2.year.ago) }
    f.avg_rate_at_lock_in_date { Random.new.rand(0.05) }
    f.original_lender_name { ["US Bank", "Provident Funding", "REMN", "UnionBank"].sample }
    f.original_lender_average_overlay { Random.new.rand(0.06) }
    f.original_estimated_interest_rate { Random.new.rand(0.06) }
    f.date_of_proposal { Faker::Date.between(1.year.from_now, 3.year.from_now) }
    f.original_estimated_mortgage_balance { Faker::Number.decimal(6, 2) }
    f.original_monthly_payment { Faker::Number.decimal(6, 2) }
    f.original_estimated_home_value { Faker::Number.decimal(6, 2) }
    f.lower_rate_loan_amount { Faker::Number.decimal(6, 2) }
    f.lower_rate_interest_rate { Random.new.rand(0.004) }
    f.lower_rate_loan_start_date { Date.today }
    f.lower_rate_estimated_closing_costs { Faker::Number.decimal(6, 2) }
    f.lower_rate_lender_credit { Faker::Number.decimal(6, 2) }
    f.lower_rate_net_closing_costs { Faker::Number.decimal(6, 2) }
    f.lower_rate_new_monthly_payment { Faker::Number.decimal(4, 2) }
    f.lower_rate_savings_1year { Faker::Number.decimal(6, 2) }
    f.lower_rate_savings_3year { Faker::Number.decimal(6, 2) }
    f.lower_rate_savings_10year { Faker::Number.decimal(6, 2) }
    f.cash_out_ltv { Random.new.rand(80) }
    f.cash_out_loan_amount { Faker::Number.decimal(6, 2) }
    f.cash_out_cash_amount { Faker::Number.decimal(6, 2) }
    f.cash_out_interest_rate { Random.new.rand(0.04) }
    f.cash_out_loan_start_date { Date.today }
    f.cash_out_estimated_closing_costs { Faker::Number.decimal(6, 2) }
    f.cash_out_lender_credit { Faker::Number.decimal(4, 2) }
    f.cash_out_net_closing_costs { Faker::Number.decimal(4, 2) }
    f.cash_out_new_monthly_payment { Faker::Number.decimal(4, 2) }
  end
end
