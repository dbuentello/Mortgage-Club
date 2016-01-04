module RatesComparisonServices
  class GetRatesFromGoogle < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      rates = get_rates(property_value, crawler)
      insert_rates_into_database(rates, "Google")
    end

    private

    def crawler
      Crawler::GoogleRates.new({
        purpose: loan.purpose,
        zipcode: property.address.zip,
        property_value: property_value,
        credit_score: borrower.credit_score,
        monthly_payment: loan.monthly_payment,
        purchase_price: property.purchase_price,
        market_price: property.market_price,
        balance: get_balance
      })
    end

    def property_value
      @property_value ||= loan.purchase? ? property.purchase_price : property.market_price
    end
  end
end
