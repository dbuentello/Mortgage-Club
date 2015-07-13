FactoryGirl.define do
  factory :borrower_race do |f|
    f.race_type { Random.rand(5) }
  end
end
