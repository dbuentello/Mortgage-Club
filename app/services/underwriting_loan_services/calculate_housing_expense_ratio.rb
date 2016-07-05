module UnderwritingLoanServices
  class CalculateHousingExpenseRatio
    def self.call(loan)
      property = loan.subject_property
      total_income = UnderwritingLoanServices::CalculateTotalIncome.call(loan)

      (property.liability_payments + property.estimated_mortgage_insurance.to_f +
      property.estimated_hazard_insurance.to_f + property.estimated_property_tax.to_f +
      property.hoa_due.to_f) / total_income
    end
  end
end
