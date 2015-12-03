FactoryGirl.define do
  factory :lender_document do |f|
    user
    loan
    lender_template
    f.description { "This is a description" }
    f.attachment { File.new(Rails.root.join 'spec', 'files', 'sample.png') }
    f.token { Faker::Lorem.characters(10) }
  end
end
