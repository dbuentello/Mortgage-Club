FactoryGirl.define do 
  factory :borrower_government_monitoring_info do |f| 
    f.is_hispanic_or_latino { [true, false].sample }
    f.gender_type { Random.rand(2) }
    
    after(:create) do |monitoring_info, evaluator|
      create_list(:borrower_race, Random.rand(1..2), borrower_government_monitoring_info: monitoring_info)
    end
  end 
end
