FactoryGirl.define do
  factory :liability do |f|
    address
    property

    f.name { Faker::Company.name }
    f.payment { Random.rand(100..5000) }
    f.months { Random.rand(1..600) }
    f.balance { Random.rand(1..999000000) }
  end
end
