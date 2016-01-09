module RatesComparisonServices
  class GetRatesFromLenda < Base
    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      rates = get_rates(crawler)
      insert_rates_into_database(rates, "Lenda")
    end

    def get_rates(crawler)
      rates = crawler.call
      thirty_year_fixed = select_rates_by_product(rates, "30 year fixed").first
      twenty_year_fixed = select_rates_by_product(rates, "20 year fixed").first
      fifteen_year_fixed = select_rates_by_product(rates, "15 year fixed").first
      ten_year_fixed = select_rates_by_product(rates, "10 year fixed").first

      [0.25, 0.2, 0.1, 0.035].each_with_object({}) do |percent, data|
        data["#{percent}"] = {
          "30_year_fixed" => thirty_year_fixed || default_rates,
          "20_year_fixed" => twenty_year_fixed || default_rates,
          "15_year_fixed" => fifteen_year_fixed || default_rates,
          "10_year_fixed" => ten_year_fixed || default_rates,
          "7_1_arm" => default_rates,
          "5_1_arm" => default_rates,
          "3_1_arm" => default_rates
        }
      end
    end

    private

    def crawler
      Crawler::LendaRates.new({
        zipcode: property.address.zip,
        market_price: property.market_price,
        balance: get_balance,
        credit_score: borrower.credit_score,
        property_type: property.property_type,
        usage: property.usage,
        annual_income: borrower.annual_income,
        monthly_debt: monthly_debt
      })
    end

    def monthly_debt
      return unless borrower.credit_report

      borrower.credit_report.sum_liability_payment - property_debt
    end

    def property_debt
      loan.properties.inject(0) { |sum, property| sum + property.mortgage_payment + property.other_financing }
    end
  end
end