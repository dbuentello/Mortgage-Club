FactoryGirl.define do
  factory :borrower_address do |f|
    address

    f.years_at_address { Random.rand(1..65) }
    f.is_rental { [true, false].sample }
    f.is_current { [true, false].sample }
  end
end