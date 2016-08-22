FactoryGirl.define do
  factory :lender_docusign_form do |f|
    f.description "MyString"
    f.sign_position "MyString"
    lender
    f.attachment { File.new(Rails.root.join 'spec', 'files', 'sample.png') }
    f.doc_order 4
    f.spouse_signed true
  end
end
