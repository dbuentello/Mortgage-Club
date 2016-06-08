module CreditReportServices
  #
  # Class Base provides clearing old credit report and call a request to Equifax
  #
  #
  class Base
    def self.call(loan)
      # clear old liabilities
      clear_credit_report(loan)
      response = CreditReportServices::GetReport.new(
        loan.borrower,
        loan.secondary_borrower
      ).call
      CreditReportServices::CreateLiabilities.call(loan, response) if response
    end

    def self.clear_credit_report(loan)
      borrower = loan.borrower
      secondary_borrower = loan.secondary_borrower

      borrower.credit_report.destroy if liabilities?(borrower.credit_report)
      secondary_borrower.credit_report.destroy if secondary_borrower && liabilities?(secondary_borrower.credit_report)
      loan.reload
    end

    def self.liabilities?(credit_report)
      return false unless credit_report.present?
      return false if credit_report.liabilities.blank?

      true
    end
  end
end
