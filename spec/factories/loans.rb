FactoryGirl.define do
  factory :loan do |f|
    user { build(:borrower_user_with_borrower) }
    lender

    f.purpose { Random.rand(0..1)}

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
    f.loan_type { ['Conventional', 'VA', 'FHA'].sample}
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

  factory :loan_with_properties, parent: :loan do |f|
    after(:build) do |loan, property|
      create(:property_with_address, loan: loan, is_subject: true, is_primary: false)
      create(:property_with_address, loan: loan, is_primary: true, is_subject: false)
      create(:property_with_address, loan: loan, is_primary: false, is_subject: false)
    end
  end

  factory :loan_with_secondary_borrower, parent: :loan do |f|
    association :secondary_borrower, factory: [:borrower, :with_user]
  end

  factory :loan_with_all_associations, parent: :loan do |f|
    after(:build) do |loan, property|
      create_list(:property, Random.rand(1..3), loan: loan)
      loan.properties.first.update(is_subject: true)
    end
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
