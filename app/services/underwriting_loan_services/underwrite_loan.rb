# underwrite a loan.
module UnderwritingLoanServices
  class UnderwriteLoan
    attr_accessor :loan, :property, :borrower, :address, :error_messages

    def initialize(loan)
      @loan = loan
      @error_messages = []
      @property = loan.subject_property
      @borrower = loan.borrower
      @address = @property.address
    end

    def call
      find_eligible_loan_programs # call it first for demo purpose

      verify_property
      verify_property_eligibility
      verify_credit_score
      # verifying_borrower_income
      # verify_debt_to_income_and_ratio
      # verify_down_payment_and_cash_reserves
      # calculate_loan_to_value_ratio
      # verify_borrower_experience

      if valid_loan?
        # find_eligible_loan_programs
        return true
      else
        return false
      end
    end

    def verify_property
      @error_messages << I18n.t("errors.subject_property_not_exist") unless property
    end

    def verify_property_eligibility
      return @error_messages << I18n.t("errors.property_must_have_address") unless address

      @error_messages << I18n.t("errors.only_in_ca") if address.state != "CA"

      unless ["sfh", "duplex", "triplex", "fourplex", "condo"].include? property.property_type
        @error_messages << I18n.t("errors.subject_property_not_eligible")
      end
    end

    def verify_credit_score
      if borrower.credit_score.nil? || borrower.credit_score < 620
        @error_messages << I18n.t("errors.credit_score_too_low")
      end
    end

    def verifying_borrower_income
    end

    def verify_debt_to_income_and_ratio
      debt_to_income = UnderwritingLoanServices::CalculateDebtToIncome.call(loan)
      ratio = UnderwritingLoanServices::CalculateHousingExpenseRatio.call(loan)

      if debt_to_income > 0.5
        @error_messages << I18n.t("errors.debt_to_income_ratio_too_high")
      end

      @error_messages << I18n.t("errors.house_expense_too_high") if ratio > 0.28
    end

    def verify_down_payment_and_cash_reserves
    end

    def calculate_loan_to_value_ratio
    end

    def verify_borrower_experience
    end

    def find_eligible_loan_programs
      LoanTekServices::GetQuotes.new(@loan).delay.call
    end

    def valid_loan?
      error_messages.empty?
    end
  end
end
