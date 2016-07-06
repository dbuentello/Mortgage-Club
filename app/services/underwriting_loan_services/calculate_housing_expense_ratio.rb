require "finance_formulas"

module UnderwritingLoanServices
  class CalculateHousingExpenseRatio
    extend FinanceFormulas

    def self.call(loan)
      property = loan.subject_property
      total_income = UnderwritingLoanServices::CalculateTotalIncome.call(loan)

      (property.liability_payments + property.estimated_mortgage_insurance.to_f +
      get_monthly_value(property.estimated_hazard_insurance) + get_monthly_value(property.estimated_property_tax) +
      property.hoa_due.to_f) / total_income
    end
  end
end
