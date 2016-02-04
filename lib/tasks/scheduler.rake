namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    rates = HomepageRateServices::CrawlMortgageAprs.delay.call(true)

    puts "done."
  end
end
