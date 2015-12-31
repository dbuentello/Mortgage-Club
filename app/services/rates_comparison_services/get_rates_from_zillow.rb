module RatesComparisonServices
  class GetRatesFromZillow < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.2, 0.1, 0.035].each_with_object({}) do |percent, data|
        crawler.down_payment = (property.purchase_price * percent).to_i
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
      @crawler ||= ZillowService::CrawlZillowRates.new({
        zipcode: property.address.zip,
        purchase_price: property.purchase_price,
        annual_income: borrower.annual_income
      })
    end
  end
end
