FactoryGirl.define do
  factory :envelope do |f|
    template

    f.docusign_id { template.docusign_id }

    after(:build) do |envelope, evaluator|
      create(:loan, envelope: envelope)
    end
  end
end
