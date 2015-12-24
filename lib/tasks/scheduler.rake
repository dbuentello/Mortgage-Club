namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    rates = MortgageRateServices::GetMortgageAprs.delay.call(true)

    puts "done."
  end

  task test: :environment do
    puts "#{Time.now}"
    rates = Crawler::GoogleRates.new({
      years: 10, monthly_payment: 2100,
      down_payment: 80000, purchase_price: 400000,
      zipcode: 95127, credit_score: 670, market_price: 390000, balance: 350000, is_refinance: false
    }).call
    ap rates
    puts "#{Time.now}"
  end
end
