FactoryGirl.define do
  factory :lender do |f|
    f.name { Faker::Company.name }
    f.website { Faker::Internet.domain_name }
    f.rate_sheet { Faker::Internet.url }
    f.lock_rate_email { Faker::Internet.email }
    f.docs_email { Faker::Internet.email }
    f.contact_email { Faker::Internet.email }
    f.contact_name { Faker::Name.name }
    f.contact_phone { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }
    f.nmls { Faker::Name.name }

    after :create do |l|
      l.lender_templates << FactoryGirl.create(:lender_template)
    end
  end
end
