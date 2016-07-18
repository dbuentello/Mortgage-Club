namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    HomepageRateServices::CreateTodayHomepageRates.call
    HomepageRateServices::GetMortgageAprs.delay.call(true) if HomepageRate.today_rates.any?

    puts "done."
  end

  desc "Crawling updated rates from fred economic"
  task update_rates_from_fred_economic: :environment do
    puts "Crawling updated rates from fred economic"
    FredEconomicServices::CrawlAvgRates.update if Time.zone.now.friday?
    puts "done."
  end

  desc "Clear quote queries were created before seven days ago"
  task clear_quote_queries: :environment do
    QuoteQuery.where("created_at < ?", 7.days.ago).destroy_all
  end

  desc "Daily update the lowest apr for quote queries "
  task update_quote_queries: :environment do
    QuoteQuery.where(alert: true).each do |q|
      QuoteService.update_graph_quote(q)
    end
  end
end
