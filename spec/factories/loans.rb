FactoryGirl.define do
  factory :loan do |f|
    user { create(:borrower_user) }

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
    association :secondary_borrower, factory: :borrower
  end

  factory :loan_with_activites, parent: :loan do |f|
    after(:build) do |loan, evaluator|
      create_list(:loan_activity, Random.rand(1..3), loan: loan)
    end
  end

end
