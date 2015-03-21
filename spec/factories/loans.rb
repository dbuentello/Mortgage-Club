FactoryGirl.define do 
  factory :loan do |f| 
    property
    borrower
    association :secondary_borrower, factory: :borrower
    f.purpose_type { Random.rand(0..1)}
  end
end