module RatesComparisonServices
  class GetRatesFromLendingTree < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.20, 0.1, 0.035].each_with_object({}) do |percent, data|
        crawler.down_payment = property.purchase_price * percent
        rates = crawler.call

        data["#{percent}"] = {
          "30_year_fixed" => get_lowest_rates(get_rates(rates, "30 year fixed")),
          "20_year_fixed" => get_lowest_rates(get_rates(rates, "20 year fixed")),
          "15_year_fixed" => get_lowest_rates(get_rates(rates, "15 year fixed")),
          "10_year_fixed" => get_lowest_rates(get_rates(rates, "10 year fixed")),
          "7_1_arm" => get_lowest_rates(get_rates(rates, "7/1 ARM")),
          "5_1_arm" => get_lowest_rates(get_rates(rates, "5/1 ARM")),
          "3_1_arm" => get_lowest_rates(get_rates(rates, "3/1 ARM"))
        }
      end
    end

    private

    def crawler
      @crawler ||= Crawler::LendingTreeRates.new({
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
      })
    end

    def property_address
      "#{property.address.city}, #{property.address.state}"
    end
  end
end