module RatesComparisonServices
  class GetRatesFromZillow < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      rates = get_rates(property.purchase_price, crawler)
      insert_rates_into_database(rates, "Zillow")
    end

    private

    def crawler
      ZillowService::CrawlZillowRates.new(
        zipcode: property.address.zip,
        purchase_price: property.purchase_price.to_i,
        annual_income: borrower.annual_income,
        number_of_results: 1
      )
    end
  end
end
