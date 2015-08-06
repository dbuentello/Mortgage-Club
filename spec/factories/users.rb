FactoryGirl.define do
  factory :user do |f|
    borrower

    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.middle_name { Faker::Name.last_name }
    f.suffix { Faker::Name.suffix }

    f.email { Faker::Internet.email }

    f.password 'password'
    f.password_confirmation 'password'
    f.confirmed_at Date.today

    factory :staff do
      borrower { nil }
      loan_member
    end
  end
end
