module CompletedLoanServices
  class BaseCompleted
    attr_accessor :loan, :subject_property,
                  :borrower, :rental_properties,
                  :primary_property, :own_investment_property,
                  :secondary_borrower

    def initialize(args)
      @loan = args[:loan]
      @subject_property = @loan.subject_property
      @borrower = loan.borrower
      @rental_properties = loan.rental_properties
      @primary_property = loan.primary_property
      @own_investment_property = loan.own_investment_property
      @secondary_borrower = loan.secondary_borrower
    end

    def call
      property_completed? && borrower_completed? && documents_completed? &&
        income_completed? && credit_completed? && assets_completed? && declarations_completed?
    end

    def property_completed?
      CompletedLoanServices::TabProperty.new(loan, subject_property).call
    end

    def borrower_completed?
      CompletedLoanServices::TabBorrower.new(
        borrower: borrower,
        secondary_borrower: secondary_borrower
      ).call
    end

    def documents_completed?
      CompletedLoanServices::TabDocuments.new(
        borrower: borrower,
        secondary_borrower: secondary_borrower
      ).call
    end

    def income_completed?
      CompletedLoanServices::TabIncome.new(
        borrower: borrower,
        current_employment: borrower.current_employment,
        previous_employment: borrower.previous_employment,
        secondary_borrower: secondary_borrower
      ).call
    end

    def credit_completed?
      # credit_check_agree
      true
    end

    def assets_completed?
      CompletedLoanServices::TabAssets.new(
        assets: borrower.assets,
        subject_property: subject_property,
        rental_properties: rental_properties,
        primary_property: primary_property,
        own_investment_property: own_investment_property,
        loan_refinance: loan.refinance?,
        borrower: borrower
      ).call
    end

    def declarations_completed?
      CompletedLoanServices::TabDeclarations.new(borrower.declaration).call
    end
  end
end
