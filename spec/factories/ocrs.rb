FactoryGirl.define do
  factory :ocr do |fac|
    borrower

    factory :ocr_with_first_document do |f|
      f.employer_name_1 { Faker::Name.name }
      f.address_first_line_1 { Faker::Address.street_address }
      f.address_second_line_1 { Faker::Address.city << " " << Faker::Address.state }
      f.period_beginning_1 { Time.zone.now }
      f.period_ending_1 { Faker::Time.between(Time.zone.now + 60, Time.zone.now) }
      f.current_salary_1 { Faker::Number.positive }
      f.ytd_salary_1 { Faker::Number.positive }
      f.current_earnings_1 { Faker::Number.positive }
    end

    factory :ocr_with_second_document do |f|
      f.employer_name_2 { Faker::Name.name }
      f.address_first_line_2 { Faker::Address.street_address }
      f.address_second_line_2 { Faker::Address.city << " " << Faker::Address.state }
      f.period_beginning_2 { Time.zone.now }
      f.period_ending_2 { Faker::Time.between(Time.zone.now + 60, Time.zone.now) }
      f.current_salary_2 { Faker::Number.positive }
      f.ytd_salary_2 { Faker::Number.positive }
      f.current_earnings_2 { Faker::Number.positive }
    end

    factory :ocr_with_full_data do |f|
      f.employer_name_1 { Faker::Name.name }
      f.address_first_line_1 { Faker::Address.street_address }
      f.address_second_line_1 { Faker::Address.city << " " << Faker::Address.state }
      f.period_beginning_1 { Time.zone.now }
      f.period_ending_1 { Faker::Time.between(Time.zone.now + 60, Time.zone.now) }
      f.current_salary_1 { Faker::Number.positive }
      f.ytd_salary_1 { Faker::Number.positive }
      f.current_earnings_1 { Faker::Number.positive }

      f.employer_name_2 { Faker::Name.name }
      f.address_first_line_2 { Faker::Address.street_address }
      f.address_second_line_2 { Faker::Address.city << " " << Faker::Address.state }
      f.period_beginning_2 { Time.zone.now }
      f.period_ending_2 { Faker::Time.between(Time.zone.now + 60, Time.zone.now) }
      f.current_salary_2 { Faker::Number.positive }
      f.ytd_salary_2 { Faker::Number.positive }
      f.current_earnings_2 { Faker::Number.positive }
    end
  end
end
