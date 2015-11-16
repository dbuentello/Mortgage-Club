module UnderwritingLoanServices
  class CalculateHousingExpenseRatio
    def self.call(loan)
      primary_property = loan.primary_property
      borrower = loan.borrower

      (primary_property.liability_payments + primary_property.estimated_mortgage_insurance.to_f +
      primary_property.estimated_hazard_insurance.to_f + primary_property.estimated_property_tax.to_f +
      primary_property.hoa_due.to_f) / borrower.total_income.to_f
    end
  end
end
