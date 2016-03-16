FactoryGirl.define do
  factory :potential_user do |f|
    f.email { Faker::Internet.email }
    f.phone_number { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }
    f.mortgage_statement { File.new(Rails.root.join 'spec', 'files', 'sample.png') }
    f.send_as_email { [true, false].sample }
    f.send_as_text_message { [true, false].sample }
  end
end
