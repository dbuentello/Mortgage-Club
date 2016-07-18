FactoryGirl.define do
  factory :declaration do |f|
    borrower
    f.type_of_property { ["PR", "SH", "IP"].sample }
    f.title_of_property { ["S", "SP", "O"].sample }
    f.outstanding_judgment { [true, false].sample }
    f.bankrupt { [true, false].sample }
    f.property_foreclosed { [true, false].sample }
    f.party_to_lawsuit { [true, false].sample }
    f.loan_foreclosure { [true, false].sample }
    f.present_delinquent_loan { [true, false].sample }
    f.child_support { [true, false].sample }
    f.down_payment_borrowed { [true, false].sample }
    f.co_maker_or_endorser { [true, false].sample }
    f.ownership_interest { [true, false].sample }
    f.citizen_status { ["C", "PR", "O"].sample }
    f.is_hispanic_or_latino { ["Y", "N"].sample }
    f.gender_type { ["F", "M"].sample }
    f.race_type { ["AIoAN", "A", "BoAA", "NHoOPI", "W"].sample }
  end

  factory :declaration_true, parent: :declaration do |f|
    f.outstanding_judgment { true }
    f.bankrupt { true }
    f.property_foreclosed { true }
    f.party_to_lawsuit { true }
    f.loan_foreclosure { true }
    f.present_delinquent_loan { true }
    f.child_support { true }
    f.down_payment_borrowed { true }
    f.co_maker_or_endorser { true }
    f.ownership_interest { true }
  end

  factory :declaration_false, parent: :declaration do |f|
    f.outstanding_judgment { false }
    f.bankrupt { false }
    f.property_foreclosed { false }
    f.party_to_lawsuit { false }
    f.loan_foreclosure { false }
    f.present_delinquent_loan { false }
    f.child_support { false }
    f.down_payment_borrowed { false }
    f.co_maker_or_endorser { false }
    f.ownership_interest { false }
  end
end
