FactoryGirl.define do
  factory :borrower, aliases: [:secondary_borrower] do |f|
    borrower_government_monitoring_info
    credit_report

    f.dob { Time.zone.today - Random.rand(21..100).to_i.years }
    f.phone { Faker::PhoneNumber.phone_number }

    # all SS numbers starting with 000 are invalid
    f.ssn { '000-' + Faker::Number.number(2) + '-' + Faker::Number.number(4) }
    f.years_in_school { Random.rand(21) }
    f.marital_status { Random.rand(3) }

    # random number of dependents (max 4), each up to age 25
    f.dependent_ages { (0...Random.rand(0..4)).to_a.map {Random.rand(1..25)} }
    f.gross_income { Faker::Number.number(7) }
    f.gross_overtime { Faker::Number.number(6) }
    f.gross_bonus { Faker::Number.number(6) }
    f.gross_commission { Faker::Number.number(6) }

    f.dependent_count { Faker::Number.number(6) }

    after(:build) do |borrower, evaluator|
      create(:employment, borrower: borrower)
      create_list(:borrower_address, 1, borrower: borrower)
    end

    trait :with_user do
      user { build(:borrower_user) }
    end

    factory :borrower_with_documents do |f|
      first_w2
      second_w2
      first_paystub
      second_paystub
      first_bank_statement
      second_bank_statement
    end

    factory :borrower_with_w2 do |f|
      first_w2
      second_w2
    end

    factory :borrower_with_paystub do |f|
      first_paystub
      second_paystub
    end

    factory :borrower_with_bank_statement do |f|
      first_bank_statement
      second_bank_statement
    end
  end
end
