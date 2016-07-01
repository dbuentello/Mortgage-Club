module CompletedLoanServices
  class TabDeclarations
    attr_accessor :borrower, :secondary_borrower

    def initialize(borrower, secondary_borrower)
      @borrower = borrower
      @secondary_borrower = secondary_borrower
    end

    def call
      return false unless borrower
      return declaration_completed?(borrower.declaration) unless secondary_borrower

      declaration_completed?(borrower.declaration) && declaration_completed?(secondary_borrower.declaration)
    end

    def declaration_completed?(declaration)
      return false if declaration.nil?

      return false if declaration.citizen_status.nil?
      return false if declaration.is_hispanic_or_latino.nil?
      return false if declaration.gender_type.nil?
      return false if declaration.race_type.nil?
      return false if declaration.ownership_interest.nil?

      if declaration.ownership_interest == true
        return false if declaration.type_of_property.nil?
        return false if declaration.title_of_property.nil?
      end

      true
    end
  end
end
