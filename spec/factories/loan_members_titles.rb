FactoryGirl.define do
  factory :loan_members_title do |f|
    f.title { Faker::Name.title }
  end
end
