FactoryGirl.define do
  factory :template do |f|
    f.name { Faker::Lorem.word }
    f.state { Faker::Address.state }
    f.description { Faker::Lorem.sentence }
    f.email_subject { Faker::Lorem.sentence }
    f.email_body { Faker::Lorem.paragraph }
    f.docusign_id { "ee4df9c1-80fd-408b-b791-334a1b75d01d" }
  end
end
