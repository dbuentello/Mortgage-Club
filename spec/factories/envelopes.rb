FactoryGirl.define do
  factory :envelope do |f|
    f.association :template
    f.association :loan

    f.docusign_id { template.docusign_id }
  end
end
