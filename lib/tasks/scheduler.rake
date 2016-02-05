namespace :scheduler do
  desc "Crawl lowest rates for displaying at homepage"
  task crawl_rates_for_homepage: :environment do
    puts "Crawling rates"

    HomepageRateServices::CreateTodayHomepageRates.call
    HomepageRateServices::GetMortgageAprs.delay.call(true) if HomepageRate.today_rates.any?

    puts "done."
  end
end
