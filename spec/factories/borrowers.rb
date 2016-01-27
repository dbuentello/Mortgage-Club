FactoryGirl.define do
  factory :borrower, aliases: [:secondary_borrower] do |f|
    borrower_government_monitoring_info

    f.dob { Time.zone.today - Random.rand(21..100).to_i.years }
    f.phone { '(' + Faker::Number.number(3) + ') ' + Faker::Number.number(3) + '-' + Faker::Number.number(4) }

    # all SS numbers starting with 000 are invalid
    f.ssn { '000-' + Faker::Number.number(2) + '-' + Faker::Number.number(4) }
    f.years_in_school { Random.rand(21) }
    f.marital_status { Random.rand(3) }

    # random number of dependents (max 4), each up to age 25
    f.dependent_ages { (1..Random.rand(2..4)).to_a }
    f.gross_income { Faker::Number.number(7) }
    f.gross_overtime { Faker::Number.number(6) }
    f.gross_bonus { Faker::Number.number(6) }
    f.gross_commission { Faker::Number.number(6) }
    # f.gross_interest { Faker::Number.number(6) } // to make income_tab_at_new_loan_page.feature:25 works well.
    f.self_employed { false }
    f.is_file_taxes_jointly { [true, false].sample }
    f.dependent_count { Faker::Number.number(6) }

    after(:build) do |borrower, evaluator|
      create(:employment, borrower: borrower, is_current: true)
      create_list(:borrower_address, 1, borrower: borrower)
    end

    trait :with_user do
      user { build(:borrower_user) }
    end

    factory :borrower_with_credit_report, parent: :borrower do |f|
      after(:build) do |borrower, credit_report|
        create(:credit_report, borrower: borrower)
      end
    end

    factory :borrower_with_documents_self_employed, parent: :borrower do |f|
      f.self_employed { true }
      after(:build) do |borrower|
        create(:document, subjectable: borrower, document_type: "first_personal_tax_return")
        create(:document, subjectable: borrower, document_type: "second_personal_tax_return")
        create(:document, subjectable: borrower, document_type: "first_business_tax_return")
        create(:document, subjectable: borrower, document_type: "second_business_tax_return")
        create(:document, subjectable: borrower, document_type: "first_bank_statement")
        create(:document, subjectable: borrower, document_type: "second_bank_statement")
      end
    end

    factory :borrower_with_documents_self_employed_taxes_joinly, parent: :borrower do |f|
      f.self_employed { true }
      after(:build) do |borrower|
        create(:document, subjectable: borrower, document_type: "first_business_tax_return")
        create(:document, subjectable: borrower, document_type: "second_business_tax_return")
        create(:document, subjectable: borrower, document_type: "first_bank_statement")
        create(:document, subjectable: borrower, document_type: "second_bank_statement")
      end
    end

    factory :borrower_with_documents_not_self_employed, parent: :borrower do |f|
      f.self_employed { false }
      after(:build) do |borrower|
        create(:document, subjectable: borrower, document_type: "first_w2")
        create(:document, subjectable: borrower, document_type: "second_w2")
        create(:document, subjectable: borrower, document_type: "first_paystub")
        create(:document, subjectable: borrower, document_type: "second_paystub")
        create(:document, subjectable: borrower, document_type: "first_federal_tax_return")
        create(:document, subjectable: borrower, document_type: "second_federal_tax_return")
        create(:document, subjectable: borrower, document_type: "first_bank_statement")
        create(:document, subjectable: borrower, document_type: "second_bank_statement")
      end
    end

    factory :borrower_with_documents_not_self_employed_taxes_joinly, parent: :borrower do |f|
      f.self_employed { false }
      after(:build) do |borrower|
        create(:document, subjectable: borrower, document_type: "first_w2")
        create(:document, subjectable: borrower, document_type: "second_w2")
        create(:document, subjectable: borrower, document_type: "first_paystub")
        create(:document, subjectable: borrower, document_type: "second_paystub")
        create(:document, subjectable: borrower, document_type: "first_bank_statement")
        create(:document, subjectable: borrower, document_type: "second_bank_statement")
      end
    end
  end
end
