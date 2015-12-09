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
    f.us_citizen { [true, false].sample }
    f.permanent_resident_alien { [true, false].sample }
    f.ownership_interest { [true, false].sample }
  end
end
