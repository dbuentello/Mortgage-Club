FactoryGirl.define do
  factory :template do |f|
    f.name { Faker::Name.first_name }
    f.state { Faker::Address.state }
    f.description { Faker::Lorem.sentence }
    f.email_subject { Faker::Lorem.sentence }
    f.email_body { Faker::Lorem.paragraph }
    f.docusign_id { Faker::Number.number(3) }
  end
end
