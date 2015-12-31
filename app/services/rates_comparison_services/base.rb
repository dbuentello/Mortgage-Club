module RatesComparisonServices
  class Base
    attr_reader :loan, :property, :borrower

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
  end
end