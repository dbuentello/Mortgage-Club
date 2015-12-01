FactoryGirl.define do
  factory :document do |f|
    f.description { "This is a description" }
    f.attachment { File.new(Rails.root.join 'spec', 'files', 'sample.png') }
    f.token { Faker::Lorem.characters(10) }
    f.user_id { create(:user) }

    factory :borrower_document, parent: :document do |f|
      f.subjectable { create(:borrower) }
      f.document_type { %w(first_w2 second_w2 first_paystub second_paystub first_bank_statement second_bank_statement
                    first_federal_tax_return second_federal_tax_return first_personal_tax_return second_personal_tax_return
                    first_business_tax_return second_business_tax_return other_borrower_report).sample }
    end

    factory :property_document, parent: :document do |f|
      f.subjectable { create(:property) }
      f.document_type { %w(appraisal_report flood_zone_certification homeowners_insurance
                    inspection_report lease_agreement mortgage_statement purchase_agreement
                    risk_report termite_report title_report other_property_report).sample }
    end

    factory :loan_document, parent: :document do |f|
      f.subjectable { create(:loan) }
      f.document_type { %w(hud_estimate hud_final loan_estimate uniform_residential_lending_application other_loan_report).sample }
    end

    factory :closing_document, parent: :document do |f|
      f.subjectable { create(:closing) }
      f.document_type { %w(closing_disclosure deed_of_trust loan_doc other_closing_report).sample }
    end
  end
end
