module RatesComparisonServices
  class Base
    attr_reader :loan, :property, :borrower

    def get_rates(rates, type)
      rates.select { |rate| rate[:product] == type }
    end

    def get_lowest_rates(rates)
      return nil if rates.empty?

      min_rate = rates.first
      rates.each { |rate| min_rate = rate if rate[:apr] < min_rate[:apr] }
      min_rate
    end
  end
end