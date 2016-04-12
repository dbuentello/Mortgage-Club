namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    HomepageRateServices::CreateTodayHomepageRates.call
    HomepageRateServices::GetMortgageAprs.delay.call(true) if HomepageRate.today_rates.any?

    puts "done."
  end

  task crawl_rates_from_fred_economic: :environment do
    puts "Crawling rates from fred economic"

    FredEconomicServices::CrawlAvgRates.call

    puts "done."
  end

  task update_rates_from_fred_economic: :environment do
    puts "Crawling rates from fred economic"

    FredEconomicServices::CrawlAvgRates.update

    puts "done."
  end

  desc "Clear quote queries were created before seven days ago"
  task clear_quote_queries: :environment do
    QuoteQuery.where("created_at < ?", 7.days.ago).destroy_all
  end
end
