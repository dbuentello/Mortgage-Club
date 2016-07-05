module UnderwritingLoanServices
  class CalculateRentalIncome
    def self.call(loan)
      loan.rental_properties.inject(0) do |sum, property|
        sum + (property.actual_rental_income.to_f - property.liability_payments.to_f -
               property.estimated_property_tax.to_f - property.estimated_hazard_insurance.to_f -
               property.estimated_mortgage_insurance.to_f - property.hoa_due.to_f)
      end
    end
  end
end
