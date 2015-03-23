FactoryGirl.define do 
  factory :borrower_employer do |f| 
    address
    f.employer_name { Faker::Company.name }
    f.employer_contact_name { Faker::Name.name }
    f.employer_contact_number { Faker::PhoneNumber.phone_number }
    f.job_title { Faker::Name.title }
    f.months_at_employer { Random.rand(13) }
    f.years_at_employer { Random.rand(51) }
    f.is_current { [true, false].sample }
  end

  factory :current_borrower_employer, parent: :borrower_employer do |f|
    f.is_current true
  end

  factory :past_borrower_employer, parent: :borrower_employer do |f|
    f.is_current false
  end
end