FactoryGirl.define do
  factory :lender_template do |f|
    f.name { "Wholesale Submission Form" } # hard code to test at Cucumber
    f.description { Faker::Lorem.sentence }
    f.is_other {false}

    factory :lender_template_with_docusign, parent: :lender_template do |f|
      f.template { create(:template, name: "Template For Docusign") }
    end
  end
end
