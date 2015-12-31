module RatesComparisonServices
  class GetRatesFromLendingTree < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.20, 0.1, 0.035].map! do |percent|
        down_payment = (property.purchase_price * percent)
        rates = Crawler::LendingTreeRates.call({
          purpose: loan.purpose,
          property_type: property.property_type,
          usage: property.usage,
          property_address: property_address,
          current_address: borrower.current_address.street_address,
          current_zip_code: borrower.current_address.zip,
          state: property.address.state,
          property_zip_code: property.address.zip,
          down_payment: down_payment,
          credit_score: borrower.credit_score,
          purchase_price: property.purchase_price,
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

    def property_address
      "#{property.address.city}, #{property.address.state}"
    end
  end
end