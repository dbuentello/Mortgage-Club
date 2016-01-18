module CompletedLoanServices
  class TabDeclarations < Base
    def self.call(loan)
      @loan = loan

      @loan.borrower.declaration && declaration_completed?(@loan.borrower.declaration)
    end

    def self.declaration_completed?(declaration)
      !(declaration.outstanding_judgment.nil? && declaration.bankrupt.nil? &&
        declaration.property_foreclosed.nil? && declaration.party_to_lawsuit.nil? &&
        declaration.loan_foreclosure.nil? && declaration.child_support.nil? &&
        declaration.down_payment_borrowed.nil? && declaration.co_maker_or_endorser.nil? &&
        declaration.us_citizen.nil? && declaration.permanent_resident_alien.nil? &&
        declaration.ownership_interest.nil? && declaration.type_of_property.nil? &&
        declaration.title_of_property.nil?)
    end
  end
end
