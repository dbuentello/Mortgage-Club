module HomepageRateServices
  class Zillow
    def self.call
      @rates = ZillowService::CrawlZillowRates.new({
        zipcode: 94103,
        purchase_price: 500000,
        down_payment: 100000,
        annual_income: 200000
      }).call

      {
        "apr_30_year" => get_lowest_rates(get_rates("30 year fixed")),
        "apr_15_year" => get_lowest_rates(get_rates("15 year fixed")),
        "apr_5_libor" => get_lowest_rates(get_rates("5/1 ARM"))
      }
    end

    def self.get_rates(type)
      @rates.select { |rate| rate[:product] == type }
    end

    def self.get_lowest_rates(rates)
      return 0 if rates.empty?

      min = 100
      rates.each { |rate| min = rate[:apr] if rate[:apr] < min }
      min
    end
  end
end
