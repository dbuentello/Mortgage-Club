module ComparisonRatesServices
  class GetRatesFromGoogle < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.20, 0.1, 0.035].map! do |percent|
        down_payment = (property_value * percent)
        rates = Crawler::CrawlGoogleRates.call({
          purpose: loan.purpose,
          zipcode: property.address.zip,
          property_value: property_value,
          down_payment: down_payment,
          credit_score: borrower.credit_score,
          monthly_payment: loan.monthly_payment,
          purchase_price: property.purchase_price,
          market_price: property.market_price,
          balance: property.mortgage_payment_liability.balance.to_f
        })

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

    private

    def property_value
      @property_value ||= loan.purchase? ? property.purchase_price : property.market_price
    end
  end
end
