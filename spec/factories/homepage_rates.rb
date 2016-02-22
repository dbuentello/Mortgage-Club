FactoryGirl.define do
  factory :homepage_rate do
    lender_name { ["Mortgage Club", "Wells Fargo", "Quicken Loans"].sample }
    program { ["15 Year Fixed", "5/1 Libor ARM", "30 Year Fixed"].sample }
    rate_value { Random.rand(1..50)/1000.0 }
    display_time { Time.zone.now }
  end

  factory :loan_tek_rate, parent: :homepage_rate do |f|
    f.lender_name { "Mortgage Club" }
  end

  factory :wellsfargo_rate, parent: :homepage_rate do |f|
    f.lender_name { "Wells Fargo" }
  end

  factory :quicken_loans_rate, parent: :homepage_rate do |f|
    f.lender_name { "Quicken Loans" }
  end
end