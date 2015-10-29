FactoryGirl.define do
  factory :ocr do |f|
    f.borrower_id Faker::Number.number(32)
    f.employer_name_1 { Faker::Name.name }
    f.employer_name_2 { Faker::Name.name }
    f.address_first_line_1 Faker::Address.street_address
    f.address_first_line_2 Faker::Address.street_address
    f.address_second_line_1 Faker::Address.street_address
    f.address_second_line_2 Faker::Address.street_address
    f.period_beginning_1  Faker::Date.backward(60)
    f.period_beginning_2  Faker::Date.backward(30)
    f.period_ending_1  Faker::Date.backward(30)
    f.period_ending_2 Faker::Date.backward(1)
    f.current_salary_1 Faker::Number.decimal(4, 2)
    f.current_salary_2 Faker::Number.decimal(4, 2)
    f.ytd_salary_1 Faker::Number.decimal(4, 2)
    f.ytd_salary_2 Faker::Number.decimal(4, 2)
    f.current_earnings_1 Faker::Number.decimal(4, 2)
    f.current_earnings_2 Faker::Number.decimal(4, 2)
  end
end
