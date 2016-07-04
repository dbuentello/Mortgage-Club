require "finance_formulas"

module UnderwritingLoanServices
  class CalculateRentalIncome
    extend FinanceFormulas

    def self.call(loan)
      loan.rental_properties.inject(0) do |sum, property|
        sum + (property.actual_rental_income.to_f - property.liability_payments.to_f -
               get_monthly_value(property.estimated_property_tax) - get_monthly_value(property.estimated_hazard_insurance) -
               property.estimated_mortgage_insurance.to_f - property.hoa_due.to_f)
      end
    end
  end
end
