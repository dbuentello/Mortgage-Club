module RateServices
  class UpdateLoanDataFromSelectedRate
    def self.call(loan_id, fees, lender)
      loan = Loan.find(loan_id)
      loan.tap do |l|
        l.appraisal_fee = fees[:appraisal_fee].to_f
        l.credit_report_fee = fees[:credit_report_fee].to_f
        l.underwriting_fee = fees[:origination_fee].to_f
        l.interest_rate = lender[:interest_rate].to_f
        l.lender_name = lender[:name]
        l.lender_nmls_id = lender[:lender_nmls_id]
        l.term_months = lender[:period].to_i
        l.amortization_type = lender[:amortization_type]
        l.monthly_payment = lender[:monthly_payment].to_f
        l.apr = lender[:apr].to_f
        l.save
      end
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error("#LoanNotFound: cannot update loan's data from selected rate. Loan id: #{loan_id}")
    end
  end
end
