FactoryGirl.define do
  factory :borrower_address do |f|
    address

    f.years_at_address { Random.rand(2..65) }
    f.is_rental { [true, false].sample }
    f.is_current { true }
    f.monthly_rent { Faker::Number.number(7) }
  end
end