FactoryGirl.define do
  factory :borrower, aliases: [:secondary_borrower] do |f|
    borrower_government_monitoring_info
    credit_report

    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.middle_name { Faker::Name.first_name }
    f.suffix { Faker::Name.suffix }
    f.dob { Date.today - Random.rand(21..100).to_i.years }

    # all SS numbers starting with 000 are invalid
    f.ssn { '000-' + Faker::Number.number(2) + '-' + Faker::Number.number(4) }
    f.phone { Faker::PhoneNumber.phone_number }
    f.years_in_school { Random.rand(21) }
    f.marital_status { Random.rand(3) }

    # random number of dependents (max 4), each up to age 25
    f.dependent_ages { (0...Random.rand(0..4)).to_a.map {Random.rand(1..25)} }
    f.gross_income { Faker::Number.number(7) }
    f.gross_overtime { Faker::Number.number(6) }
    f.gross_bonus { Faker::Number.number(6) }
    f.gross_commission { Faker::Number.number(6) }

    after(:create) do |borrower, evaluator|
      create_list(:borrower_address, Random.rand(1..2), borrower: borrower)
      create_list(:bank_statement, Random.rand(0..2), borrower: borrower)
      create_list(:brokerage_statement, Random.rand(0..2), borrower: borrower)
      create_list(:paystub, Random.rand(0..4), borrower: borrower)
      create_list(:w2, Random.rand(0..2), borrower: borrower)
    end
  end
end
