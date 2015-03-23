FactoryGirl.define do 
  factory :loan do |f| 
    user
    f.purpose_type { Random.rand(0..1)}
  end

  factory :loan_with_property, parent: :loan do |f|
    property
  end

  factory :loan_with_secondary_borrower, parent: :loan do |f|
    association :secondary_borrower, factory: :borrower
  end

  factory :loan_with_all_associations, parent: :loan do |f|
    property
    borrower
    association :secondary_borrower, factory: :borrower
  end
end
