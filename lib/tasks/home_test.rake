namespace :home_test do
  desc "Get mortgage rates for take home test"
  task crawl_rates_for_home_test: :environment do
    rates = ZillowService::CrawlZillowRates.new({
      zipcode: 94103,
      purchase_price: 500000,
      down_payment: 100000,
      annual_income: 200000
    }).call

    REDIS.set("rates_for_home_test", rates.to_json)
    REDIS.expire("rates_for_home_test", 1.year.to_i)
  end
end
