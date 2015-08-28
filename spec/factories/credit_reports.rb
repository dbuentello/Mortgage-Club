FactoryGirl.define do
  factory :credit_report do |f|
    f.date { Faker::Date.between(59.days.ago, Time.zone.today) }
    f.score { Random.rand(300..850) }

    after(:build) do |credit_report, evaluator|
      create_list(:liability, Random.rand(0..5), credit_report: credit_report)
    end
  end
end
