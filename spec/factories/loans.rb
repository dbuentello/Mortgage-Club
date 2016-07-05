FactoryGirl.define do
  factory :loan do |f|
    user { build(:borrower_user_with_borrower) }
    lender

    f.purpose { Random.rand(0..1) }

    f.agency_case_number { Faker::Lorem.word }
    f.lender_case_number { Faker::Lorem.word }
    f.amount { Faker::Number.decimal(6, 2) }
    f.interest_rate { Faker::Number.decimal(1, 3) }
    f.num_of_months { Faker::Number.number(2) }
    f.amortization_type { ['15 year fixed', '30 year fixed'].sample }
    f.rate_lock { [true, false].sample }
    f.refinance { Faker::Number.decimal(6, 2) }
    f.estimated_prepaid_items { Faker::Number.decimal(6, 2) }
    f.estimated_closing_costs { Faker::Number.decimal(6, 2) }
    f.pmi_mip_funding_fee { Faker::Number.decimal(6, 2) }
    f.borrower_closing_costs { Faker::Number.decimal(6, 2) }
    f.other_credits { Faker::Number.decimal(6, 2) }
    f.other_credits_explain { Faker::Lorem.word }
    f.pmi_mip_funding_fee_financed { Faker::Number.decimal(6, 2) }
    f.loan_type { ['Conventional', 'VA', 'FHA'].sample }
    f.prepayment_penalty { [true, false].sample }
    f.balloon_payment { [true, false].sample }
    f.monthly_payment { Faker::Number.decimal(6, 2) }
    f.prepayment_penalty_amount { Faker::Number.decimal(6, 2) }
    f.pmi { Faker::Number.decimal(6, 2) }
    f.status { "new_loan" }
    f.service_cannot_shop_fees { {fees: [], total: 0} }
    f.origination_charges_fees { {fees: [], total: 0} }
    f.service_can_shop_fees { {fees: [], total: 0} }
  end

  factory :loan_with_properties, parent: :loan do
    after(:build) do |loan, _property|
      create(:property_with_address, loan: loan, is_subject: true, is_primary: false)
      create(:property_with_address, loan: loan, is_primary: true, is_subject: false)
      create(:property_with_address, loan: loan, is_primary: false, is_subject: false)
    end
  end

  factory :loan_with_secondary_borrower, parent: :loan do
    association :secondary_borrower, factory: [:borrower, :with_user]
  end

  factory :loan_with_all_associations, parent: :loan do
    after(:build) do |loan, _property|
      create_list(:property, Random.rand(1..3), loan: loan)
      loan.properties.first.update(is_subject: true)
    end
    closing
    association :secondary_borrower, factory: :borrower
  end

  factory :loan_with_activites, parent: :loan do
    after(:build) do |loan, _evaluator|
      create_list(:loan_activity, Random.rand(1..3), loan: loan)
    end
  end

  factory :loan_with_closing, parent: :loan do
    closing
  end

  factory :loan_with_loan_member, parent: :loan do
    after(:build) do |loan|
      create(:loans_members_association, loan: loan)
    end
  end

  factory :loan_completed, parent: :loan do |f|
    f.purpose { "purchase" }
    f.amount { 400000.0 }
    f.down_payment { 100000.0 }
    f.status { "new_loan" }
    f.agency_case_number { nil }
    f.lender_case_number { nil }
    f.interest_rate { nil }
    f.num_of_months { nil }
    f.amortization_type { nil }
    f.rate_lock { nil }
    f.refinance { nil }
    f.estimated_prepaid_items { nil }
    f.estimated_closing_costs { nil }
    f.pmi_mip_funding_fee { nil }
    f.loan_type { nil }
    f.credit_check_agree {true}
    f.prepayment_penalty { nil }
    f.balloon_payment { nil }
    f.monthly_payment { nil }
    f.prepayment_penalty_amount { nil }
    f.pmi { nil }

    f.user { build(:borrower_user_with_borrower_completed) }
    f.properties { [build(:subject_property_completed), build(:primary_property_completed)] }
  end
end
