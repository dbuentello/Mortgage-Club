FactoryGirl.define do
  factory :lender_template do |f|
    template
    f.name { "Wholesale Submission Form" } # hard code to test at Cucumber
    f.description { Faker::Lorem.sentence }

    factory :lender_template_without_docusign, parent: :lender_template do |f|
      f.template { nil }
    end
  end
end
