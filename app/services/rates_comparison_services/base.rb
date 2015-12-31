module RatesComparisonServices
  class Base
    attr_reader :loan, :property, :borrower

    def initialize(loan, property, borrower)
      @loan = loan
      @property = property
      @borrower = borrower
    end

    def call
      zillow_rates = RatesComparisonServices::GetRatesFromZillow.new(loan, property, borrower).call
      insert_rates_into_database(zillow_rates, "Zillow")
      ap "done Zillow"
      lending_tree_rates = RatesComparisonServices::GetRatesFromLendingTree.new(loan, property, borrower).call
      insert_rates_into_database(lending_tree_rates, "Lending Tree")
      ap "done Lending Tree"
      google_rates = RatesComparisonServices::GetRatesFromGoogle.new(loan, property, borrower).call
      insert_rates_into_database(google_rates, "Google")
    end

    def get_rates(rates, type)
      rates.select { |rate| rate[:product] == type }
    end

    def get_lowest_rates(rates)
      return default_rates if rates.empty?

      min_rate = rates.first
      rates.each { |rate| min_rate = rate if rate[:apr] < min_rate[:apr] }
      min_rate.slice(:product, :apr, :lender_name, :total_fee)
    end

    def get_balance
      return 0 unless property.mortgage_payment_liability

      property.mortgage_payment_liability.balance.to_f
    end

    private

    def default_rates
      {product: "", apr: 0, lender_name: "", total_fee: 0}
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
  end
end
