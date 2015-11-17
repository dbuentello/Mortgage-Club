module UnderwritingLoanServices
  class CalculateDebtToIncome
    def self.call(loan)
      return 1 unless credit_report = loan.borrower.credit_report # it'll will be updated when removing sample xml
      total_income = UnderwritingLoanServices::CalculateTotalIncome.call(loan)
      (credit_report.sum_liability_payment - sum_investment(loan.rental_properties)) / total_income
    end

    def self.sum_investment(properties)
      properties.inject(0) do |sum, property|
        sum + property.mortgage_payment + property.other_financing
      end
    end
  end
end
