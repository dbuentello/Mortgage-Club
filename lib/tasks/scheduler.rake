namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    rates = MortgageRateServices::GetMortgageAprs.delay.call(true)

    puts "done."
  end

  task test: :environment do
    puts "#{Time.now}"
    rates = Crawler::LendingTreeRates.new({
      purpose: "Purchase", property_type: "sfh",
      usage: "primary_residence", property_address: "California, PA", state: "California",
      current_address: "1722 Silver Meadow Court", purchase_price: 400000, down_payment: 50000,
      credit_score: 690, current_zip_code: 95121, property_zip_code: 95121,
      has_second_mortgage: true, first_mortgage_payment: 5000,
      second_mortgage_payment: 3000
    }).call
    ap rates
    puts "#{Time.now}"
  end

  task debug: :environment do
    loan = Loan.find("cd70d96b-3902-44dd-a840-9ef762aa96a2")
    borrower = User.where(email:"borrower@gmail.com").last.borrower
    RatesComparisonServices::Base.new(loan, loan.subject_property, borrower).call
  end
end
