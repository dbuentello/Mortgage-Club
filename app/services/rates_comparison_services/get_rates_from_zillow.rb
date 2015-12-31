module RatesComparisonServices
  class GetRatesFromZillow < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      [0.25, 0.20, 0.1, 0.035].inject({}) do |data, percent|
        down_payment = (property.purchase_price * percent).to_i
        rates = ZillowService::CrawlZillowRates.new({
          zipcode: property.address.zip,
          purchase_price: property.purchase_price,
          down_payment: down_payment,
          annual_income: borrower.annual_income
        }).call

        data["#{percent}"] = {
          "30_year_fixed" => get_lowest_rates(get_rates(rates, "30 year fixed")),
          "20_year_fixed" => get_lowest_rates(get_rates(rates, "20 year fixed")),
          "15_year_fixed" => get_lowest_rates(get_rates(rates, "15 year fixed")),
          "10_year_fixed" => get_lowest_rates(get_rates(rates, "10 year fixed")),
          "7_1_arm" => get_lowest_rates(get_rates(rates, "7/1 ARM")),
          "5_1_arm" => get_lowest_rates(get_rates(rates, "5/1 ARM")),
          "3_1_arm" => get_lowest_rates(get_rates(rates, "3/1 ARM"))
        }
        data
      end
    end

    private

    def get_rates(rates, type)
      rates.select { |rate| rate[:product] == type }
    end

    def get_lowest_rates(rates)
      return default_rates if rates.empty?

      min_rate = rates.first
      rates.each { |rate| min_rate = rate if rate[:apr] < min_rate[:apr] }
      min_rate.slice(:product, :apr, :lender_name, :total_fee)
    end

    def default_rates
      {product: "", apr: 0, lender_name: "", total_fee: 0}
    end
  end
end
