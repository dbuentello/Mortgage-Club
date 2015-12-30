FactoryGirl.define do
  factory :rate_comparison do |f|
    loan
    f.down_payment_percentage { [0.2, 0.3, 0.15, 0.1].sample }
    f.lender_name { Faker::Name.name }
  end
end
