module UnderwritingLoanServices
  class CalculateDebtToIncome
    def self.call(loan)
      sum_liability_payment(loan.properties) - sum_investment(loan.rental_properties)
    end

    def self.sum_liability_payment(properties)
      properties.inject(0) do |sum, property|
        sum + property.liability_payments
      end
    end

    def self.sum_investment(properties)
      properties.inject(0) do |sum, property|
        sum + property.mortgage_payment + property.other_financing
      end
    end
  end
end
