# for loan member. We get rates from Zillow, Lending Tree, Google and Lenda and compare their rates with our rate.
module RatesComparisonServices
  class Base
    attr_reader :loan, :property, :borrower

    def initialize(loan_id, user_id)
      user = User.find(user_id)
      @loan = Loan.find(loan_id)
      @property = @loan.subject_property
      @borrower = user.borrower
    end

    def call
      RatesComparisonServices::GetRatesFromZillow.new(loan, property, borrower).delay.call
      RatesComparisonServices::GetRatesFromLendingTree.new(loan, property, borrower).delay.call
      RatesComparisonServices::GetRatesFromGoogle.new(loan, property, borrower).delay.call
      RatesComparisonServices::GetRatesFromLenda.new(loan, property, borrower).delay.call
    end

    def get_rates(property_value, crawler)
      [0.25, 0.2, 0.1, 0.035].each_with_object({}) do |percent, data|
        crawler.down_payment = (property_value * percent).to_i
        rates = crawler.call

        data["#{percent}"] = {
          "30_year_fixed" => get_lowest_rates(select_rates_by_product(rates, "30 year fixed")),
          "20_year_fixed" => get_lowest_rates(select_rates_by_product(rates, "20 year fixed")),
          "15_year_fixed" => get_lowest_rates(select_rates_by_product(rates, "15 year fixed")),
          "10_year_fixed" => get_lowest_rates(select_rates_by_product(rates, "10 year fixed")),
          "7_1_arm" => get_lowest_rates(select_rates_by_product(rates, "7/1 ARM")),
          "5_1_arm" => get_lowest_rates(select_rates_by_product(rates, "5/1 ARM")),
          "3_1_arm" => get_lowest_rates(select_rates_by_product(rates, "3/1 ARM"))
        }
      end
    end

    def get_balance
      return 0 unless property.mortgage_payment_liability

      property.mortgage_payment_liability.balance.to_f
    end

    def insert_rates_into_database(rates, competitor_name)
      [0.25, 0.2, 0.1, 0.035].each do |percent|
        rate_comparision = RateComparison.find_or_initialize_by(
          loan: loan,
          competitor_name: competitor_name,
          down_payment_percentage: percent
        )
        rate_comparision.rates = rates["#{percent}"]
        rate_comparision.save
      end
    end

    def select_rates_by_product(rates, type)
      rates.select { |rate| rate[:product] == type }
    end

    def default_rates
      {product: "", apr: 0, lender_name: "", total_fee: 0}
    end

    private

    def get_lowest_rates(rates)
      return default_rates if rates.empty?

      min_rate = rates.first
      rates.each { |rate| min_rate = rate if rate[:apr] < min_rate[:apr] }
      min_rate.slice(:product, :apr, :lender_name, :total_fee)
    end
  end
end
