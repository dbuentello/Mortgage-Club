FactoryGirl.define do
  factory :employment do
    address
    borrower

    employer_name { Faker::Name.name }
    employer_contact_name { Faker::Name.name }
    employer_contact_number { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }
    job_title { Faker::Lorem.word }
    duration { Random.rand(2..100) }
    pay_frequency { Random.rand(1..100) }
    current_salary { Random.rand(1..100) }
    is_current { false }
  end
end
