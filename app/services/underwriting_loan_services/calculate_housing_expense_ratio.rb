module UnderwritingLoanServices
  class CalculateHousingExpenseRatio
    def self.call(loan)
      primary_property = loan.primary_property
      borrower = loan.borrower

      (primary_property.liability_payments + primary_property.estimated_mortgage_insurance +
      primary_property.estimated_hazard_insurance + primary_property.estimated_property_tax +
      primary_property.hoa_due) / borrower.total_income
    end
  end
end
