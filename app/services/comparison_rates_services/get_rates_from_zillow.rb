module ComparisonRatesServices
  class GetRatesFromZillow
    def self.call(zipcode, purchase_price, annual_income)
      [0.25, 0.20, 0.1, 0.035].map! do |percent|
        down_payment = (purchase_price * percent).to_i
        @rates = ZillowService::CrawlZillowRates.new({
          zipcode: zipcode,
          purchase_price: purchase_price,
          down_payment: down_payment,
          annual_income: annual_income
        }).call

        {
          "#{percent}" => {
            "apr_30_year" => get_lowest_rates(get_rates("30 year fixed")),
            "apr_20_year" => get_lowest_rates(get_rates("20 year fixed")),
            "apr_15_year" => get_lowest_rates(get_rates("15 year fixed")),
            "apr_10_year" => get_lowest_rates(get_rates("10 year fixed")),
            "apr_7_libor" => get_lowest_rates(get_rates("7/1 ARM")),
            "apr_5_libor" => get_lowest_rates(get_rates("5/1 ARM")),
            "apr_3_libor" => get_lowest_rates(get_rates("3/1 ARM"))
          }
        }
      end
    end

    private

    def self.get_rates(type)
      @rates.select { |rate| rate[:product] == type }
    end

    def self.get_lowest_rates(rates)
      return nil if rates.empty?

      min_rate = rates.first
      rates.each { |rate| min_rate = rate if rate[:apr] < min_rate[:apr] }
      min_rate
    end
  end
end
