module RatesComparisonServices
  class GetRatesFromZillow < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.20, 0.1, 0.035].map! do |percent|
        down_payment = (property.purchase_price * percent).to_i
        rates = ZillowService::CrawlZillowRates.new({
          zipcode: property.address.zip,
          purchase_price: property.purchase_price,
          down_payment: down_payment,
          annual_income: borrower.annual_income
        }).call

        {
          "#{percent}" => {
            "apr_30_year" => get_lowest_rates(get_rates(rates, "30 year fixed")),
            "apr_20_year" => get_lowest_rates(get_rates(rates, "20 year fixed")),
            "apr_15_year" => get_lowest_rates(get_rates(rates, "15 year fixed")),
            "apr_10_year" => get_lowest_rates(get_rates(rates, "10 year fixed")),
            "apr_7_libor" => get_lowest_rates(get_rates(rates, "7/1 ARM")),
            "apr_5_libor" => get_lowest_rates(get_rates(rates, "5/1 ARM")),
            "apr_3_libor" => get_lowest_rates(get_rates(rates, "3/1 ARM"))
          }
        }
      end
    end
  end
end
