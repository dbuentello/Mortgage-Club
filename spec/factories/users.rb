FactoryGirl.define do
  factory :user do |f|
    borrower

    f.email { Faker::Internet.email }
    f.password 'guest123'
    f.password_confirmation 'guest123'
  end
end
