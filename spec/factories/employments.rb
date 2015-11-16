FactoryGirl.define do
  factory :employment do |f|
    address
    borrower

    employer_name { Faker::Name.name }
    employer_contact_name { Faker::Name.name }
    employer_contact_number { Faker::PhoneNumber.cell_phone }
    job_title { Faker::Lorem.word }
    duration { Random.rand(1..100) }
    is_current { false }
  end
end
