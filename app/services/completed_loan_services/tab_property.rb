module CompletedLoanServices
  class TabProperty
    def self.call(loan)
      loan.properties.size > 0 && loan.subject_property && loan.subject_property.completed? && purpose_completed?(loan)
    end

    def self.purpose_completed?(loan)
      loan.purpose.present? && loan.subject_property && (loan.purchase? && loan.subject_property.purchase_price.present? ||
        loan.refinance? && loan.subject_property.refinance_completed?)
    end
  end
end
