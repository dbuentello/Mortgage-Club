module CreditReportServices
  #
  # Class Base provides clearing old credit report and call a request to Equifax
  #
  #
  class Base
    def self.call(loan)
      call_credit_check(loan.borrower)
      # call_credit_check(loan.secondary_borrower) if loan.secondary_borrower
    end

    def self.call_credit_check(borrower)
      return if credit_report_was_within_90_days?(borrower)
      # clear old liabilities
      clear_credit_report(borrower)
      return unless response = CreditReportServices::GetReport.new(borrower).call

      CreditReportServices::CreateLiabilities.call(borrower, response)
      borrower.credit_report.update(last_run_at: Time.zone.now)
    end

    def self.clear_credit_report(borrower)
      borrower.credit_report.destroy if liabilities?(borrower.credit_report)
    end

    def self.liabilities?(credit_report)
      return false unless credit_report.present?
      return false if credit_report.liabilities.blank?

      true
    end

    def self.credit_report_was_within_90_days?(borrower)
      return false unless borrower.credit_report
      return false unless borrower.credit_report.last_run_at

      Time.zone.now <= borrower.credit_report.last_run_at + 90.days
    end
  end
end
