module RatesComparisonServices
  class GetRatesFromLendingTree < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      rates = get_rates(property.purchase_price, crawler)
      insert_rates_into_database(rates, "Lending Tree")
    end

    private

    def crawler
      Crawler::LendingTreeRates.new(
        purpose: loan.purpose,
        property_type: property.property_type,
        usage: property.usage,
        property_address: property_address,
        current_address: borrower.current_address.address.street_address,
        current_zip_code: borrower.current_address.address.zip,
        state: property.address.state,
        property_zip_code: property.address.zip,
        credit_score: borrower.credit_score,
        purchase_price: property.purchase_price,
        balance: get_balance
      )
    end

    def property_address
      "#{property.address.city}, #{property.address.state}"
    end
  end
end