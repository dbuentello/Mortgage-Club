FactoryGirl.define do
  factory :user do |f|
    borrower

    f.email { Faker::Internet.email }

    f.password 'password'
    f.password_confirmation 'password'
    f.confirmed_at Date.today

    factory :staff do
      borrower { nil }
    end
  end
end
