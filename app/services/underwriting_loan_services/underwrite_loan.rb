module UnderwritingLoanServices
  class UnderwriteLoan
    attr_accessor :loan, :property, :borrower, :address, :error_messages

    def initialize(loan)
      @loan = loan
      @error_messages = []
      @property = loan.primary_property
      @borrower = loan.borrower
      @address = @property.address
    end

    def call
      find_eligible_loan_programs # call it first for demo purpose
      return true # demo purpose only

      # verify_property
      # verify_property_eligibility
      # verify_credit_score
      # # verifying_borrower_income
      # verify_debt_to_income_and_ratio
      # # verify_down_payment_and_cash_reserves
      # # calculate_loan_to_value_ratio
      # # verify_borrower_experience

      # if valid_loan?
      #   # find_eligible_loan_programs
      #   return true
      # else
      #   return false
      # end
    end


    def verify_property
      @error_messages << "Sorry, your subject property does not exist." unless property
    end

    def verify_property_eligibility
      return @error_messages << "Sorry, your property must have an address." unless address

      if address.state != "CA"
        @error_messages << "Sorry, we only lend in CA at this time. We'll contact you once we're ready to lend in."
      end

      unless ["sfh", "duplex", "triplex", "fourplex", "condo"].include? property.property_type
        @error_messages << "Sorry, your subject property is not eligible. We only offer loan programs for residential 1-4 units at this time."
      end
    end

    def verify_credit_score
      if borrower.credit_score.nil? || borrower.credit_score < 620
        @error_messages << "Sorry, your credit score is below the minimum required to obtain a mortgage."
      end
    end

    def verifying_borrower_income
    end

    def verify_debt_to_income_and_ratio
      debt_to_income = UnderwritingLoanServices::CalculateDebtToIncome.call(loan)
      ratio = UnderwritingLoanServices::CalculateHousingExpenseRatio.call(loan)

      if debt_to_income > 0.5
        @error_messages << "Your debt-to-income ratio is too high. We can't find any loan programs for you."
      end

      if ratio > 0.28
        @error_messages << "Your housing expense is currently too high. We can't find any loan programs for you."
      end
    end

    def verify_down_payment_and_cash_reserves
    end

    def calculate_loan_to_value_ratio
    end

    def verify_borrower_experience
    end

    def find_eligible_loan_programs
      if address.zip.present?
        ZillowService::GetMortgageRates.new(loan.id, address.zip).delay.call
      end
    end

    def valid_loan?
      error_messages.empty?
    end
  end
end
