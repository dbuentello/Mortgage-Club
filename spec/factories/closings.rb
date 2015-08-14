FactoryGirl.define do
  factory :closing do |f|
    f.name { Faker::Lorem.word }
  end
end
