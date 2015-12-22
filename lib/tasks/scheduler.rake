namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    rates = MortgageRateServices::GetMortgageAprs.delay.call(true)

    puts "done."
  end

  task test: :environment do
    puts "#{Time.now}"
    rates = ComparisonRatesServices::GetRatesFromZillow.call(94103, 500000, 200000)
    puts "#{Time.now}"
  end
end
