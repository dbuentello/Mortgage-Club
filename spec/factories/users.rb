FactoryGirl.define do 
  factory :user do |f|
    borrower
    f.email { Faker::Internet.email }
    f.password 'guest'
    f.password_confirmation 'guest'
  end
end
