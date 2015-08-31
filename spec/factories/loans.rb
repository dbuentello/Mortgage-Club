# == Schema Information
#
# Table name: loans
#
#  id                                  :uuid             not null, primary key
#  purpose                             :integer
#  user_id                             :uuid
#  agency_case_number                  :string
#  lender_case_number                  :string
#  amount                              :decimal(11, 2)
#  interest_rate                       :decimal(9, 3)
#  num_of_months                       :integer
#  amortization_type                   :string
#  rate_lock                           :boolean
#  refinance                           :decimal(11, 2)
#  estimated_prepaid_items             :decimal(11, 2)
#  estimated_closing_costs             :decimal(11, 2)
#  pmi_mip_funding_fee                 :decimal(11, 2)
#  borrower_closing_costs              :decimal(11, 2)
#  other_credits                       :decimal(11, 2)
#  other_credits_explain               :string
#  pmi_mip_funding_fee_financed        :decimal(11, 2)
#  loan_type                           :string
#  prepayment_penalty                  :boolean
#  balloon_payment                     :boolean
#  monthly_payment                     :decimal(11, 2)
#  prepayment_penalty_amount           :decimal(11, 2)
#  pmi                                 :decimal(11, 2)
#  loan_amount_increase                :boolean
#  interest_rate_increase              :boolean
#  included_property_taxes             :boolean
#  included_homeowners_insurance       :boolean
#  included_other                      :boolean
#  included_other_text                 :boolean
#  in_escrow_property_taxes            :boolean
#  in_escrow_homeowners_insurance      :boolean
#  in_escrow_other                     :boolean
#  loan_costs                          :decimal(11, 2)
#  other_costs                         :decimal(11, 2)
#  lender_credits                      :decimal(11, 2)
#  estimated_cash_to_close             :decimal(11, 2)
#  lender_name                         :string
#  fha_upfront_premium_amount          :decimal(11, 2)
#  term_months                         :integer
#  lock_period                         :integer
#  margin                              :decimal(11, 2)
#  pmi_annual_premium_mount            :decimal(11, 2)
#  pmi_monthly_premium_amount          :decimal(11, 2)
#  pmi_monthly_premium_percent         :decimal(11, 4)
#  pmi_required                        :boolean
#  apr                                 :decimal(11, 3)
#  price                               :decimal(11, 3)
#  product_code                        :string
#  product_index                       :integer
#  total_margin_adjustment             :decimal(11, 2)
#  total_price_adjustment              :decimal(11, 2)
#  total_rate_adjustment               :decimal(11, 2)
#  srp_adjustment                      :decimal(11, 2)
#  appraisal_fee                       :decimal(11, 2)
#  city_county_deed_stamp_fee          :decimal(11, 2)
#  credit_report_fee                   :decimal(11, 2)
#  document_preparation_fee            :decimal(11, 2)
#  flood_certification                 :decimal(11, 2)
#  origination_fee                     :decimal(11, 2)
#  settlement_fee                      :decimal(11, 2)
#  state_deed_tax_stamp_fee            :decimal(11, 2)
#  tax_related_service_fee             :decimal(11, 2)
#  title_insurance_fee                 :decimal(11, 2)
#  monthly_principal_interest_increase :boolean
#

FactoryGirl.define do
  factory :loan do |f|
    user { build(:borrower_user_with_borrower) }

    f.purpose { Random.rand(0..1)}

    f.agency_case_number { Faker::Lorem.word }
    f.lender_case_number { Faker::Lorem.word }
    f.amount { Faker::Number.decimal(6, 2) }
    f.interest_rate { Faker::Number.decimal(1, 3) }
    f.num_of_months { Faker::Number.number(2) }
    f.amortization_type { ['Conventional', 'VA', 'FHA', 'USDA', '9'].sample }
    f.rate_lock { [true, false].sample }
    f.refinance { Faker::Number.decimal(6, 2) }
    f.estimated_prepaid_items { Faker::Number.decimal(6, 2) }
    f.estimated_closing_costs { Faker::Number.decimal(6, 2) }
    f.pmi_mip_funding_fee { Faker::Number.decimal(6, 2) }
    f.borrower_closing_costs { Faker::Number.decimal(6, 2) }
    f.other_credits { Faker::Number.decimal(6, 2) }
    f.other_credits_explain { Faker::Lorem.word }
    f.pmi_mip_funding_fee_financed { Faker::Number.decimal(6, 2) }
    f.loan_type { ['Conventional', 'VA', 'FHA', Faker::Lorem.word].sample }
    f.prepayment_penalty { [true, false].sample }
    f.balloon_payment { [true, false].sample }
    f.monthly_payment { Faker::Number.decimal(6, 2) }
    f.prepayment_penalty_amount { Faker::Number.decimal(6, 2) }
    f.pmi { Faker::Number.decimal(6, 2) }
  end

  factory :loan_with_property, parent: :loan do |f|
    property
  end

  factory :loan_with_secondary_borrower, parent: :loan do |f|
    association :secondary_borrower, factory: :borrower
  end

  factory :loan_with_all_associations, parent: :loan do |f|
    property
    borrower
    closing
    association :secondary_borrower, factory: :borrower
  end

  factory :loan_with_activites, parent: :loan do |f|
    after(:build) do |loan, evaluator|
      create_list(:loan_activity, Random.rand(1..3), loan: loan)
    end
  end

  factory :loan_with_closing, parent: :loan do |f|
    closing
  end

  factory :loan_with_loan_member, parent: :loan do |f|
    after(:build) do |loan|
      create(:loans_members_association, loan: loan)
    end
  end
end
