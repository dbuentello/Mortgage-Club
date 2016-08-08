module CreditReportServices
  #
  # Class Base provides clearing old credit report and call a request to Equifax
  #
  #
  class Base
    def self.call(loan)
      # return if credit_report_was_within_90_days?(loan)
      # clear old liabilities
      clear_credit_report(loan.borrower)
      clear_credit_report(loan.secondary_borrower) if loan.secondary_borrower
      response = CreditReportServices::GetReport.new(loan.borrower, loan.secondary_borrower).call

      if response
        CreditReportServices::CreateLiabilities.call(loan, response)

        if loan.borrower.user.first_name != "Mortgage" && loan.borrower.user.last_name != "Club" && loan.borrower.ssn != "111-11-1111"
          CreditReportServices::SaveCreditReportAsPdf.call(loan, response)
        end
        remember_last_run_at_of_credit_report(loan)
      end
    end

    def self.clear_credit_report(borrower)
      return unless liabilities?(borrower.credit_report)
      borrower.credit_report.destroy
      borrower.reload
    end

    def self.liabilities?(credit_report)
      return false unless credit_report.present?
      return false if credit_report.liabilities.blank?

      true
    end

    def self.credit_report_was_within_90_days?(loan)
      borrower = loan.borrower
      co_borrower = loan.secondary_borrower

      if co_borrower
        return false unless borrower.credit_report && co_borrower.credit_report
        return false unless borrower.credit_report.last_run_at && co_borrower.credit_report.last_run_at
        return Time.zone.now <= borrower.credit_report.last_run_at + 90.days && Time.zone.now <= co_borrower.credit_report.last_run_at + 90.days
      else
        return false unless borrower.credit_report
        return false unless borrower.credit_report.last_run_at
        return Time.zone.now <= borrower.credit_report.last_run_at + 90.days
      end
    end

    def self.remember_last_run_at_of_credit_report(loan)
      if loan.borrower.credit_report
        loan.borrower.credit_report.update(last_run_at: Time.zone.now)
      end

      if loan.secondary_borrower && loan.secondary_borrower.credit_report
        loan.secondary_borrower.credit_report.update(last_run_at: Time.zone.now)
      end
    end
  end
end
