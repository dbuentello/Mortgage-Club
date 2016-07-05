module UnderwritingLoanServices
  class CalculateTotalIncome
    def self.call(loan)
      borrower = loan.borrower
      co_borrower = loan.secondary_borrower

      rental_income = UnderwritingLoanServices::CalculateRentalIncome.call(loan)
      borrower_income = borrower.current_salary.to_f + borrower.gross_overtime.to_f + borrower.gross_commission.to_f
      co_borrower_income = co_borrower.current_salary.to_f + co_borrower.gross_overtime.to_f + co_borrower.gross_commission.to_f if co_borrower.present?

      rental_income + borrower_income + co_borrower_income.to_f
    end
  end
end
