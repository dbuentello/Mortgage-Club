FactoryGirl.define do
  factory :homepage_rate do
    lender_name { ["Mortgage Club", "Wells Fargo", "Quicken Loans"].sample }
    program { ["15 Year Fixed", "5/1 Libor ARM", "30 Year Fixed"].sample }
    rate_value { Random.rand(1..50)/1000.0 }
  end
end