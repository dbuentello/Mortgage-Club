module RatesComparisonServices
  class GetRatesFromGoogle < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.20, 0.1, 0.035].inject({}) do |data, percent|
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

        data["#{percent}"] = {
          "30_year_fixed" => get_rates(rates, "30 year fixed"),
          "20_year_fixed" => get_rates(rates, "20 year fixed"),
          "15_year_fixed" => get_rates(rates, "15 year fixed"),
          "10_year_fixed" => get_rates(rates, "10 year fixed"),
          "7_1_arm" => get_rates(rates, "7/1 ARM"),
          "5_1_arm" => get_rates(rates, "5/1 ARM"),
          "3_1_arm" => get_rates(rates, "3/1 ARM")
        }
        data
      end
    end

    private

    def property_value
      @property_value ||= loan.purchase? ? property.purchase_price : property.market_price
    end
  end
end
