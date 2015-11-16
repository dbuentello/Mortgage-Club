module UnderwritingLoanServices
  class CalculateTotalIncome
    def self.call(loan)
      borrower = loan.borrower

      rental_income = UnderwritingLoanServices::CalculateRentalIncome.call(loan)
      borrower.current_salary + borrower.gross_overtime.to_f + borrower.gross_commission.to_f + rental_income
    end
  end
end