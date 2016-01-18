module CompletedLoanServices
  class TabIncome < Base
    def self.call(loan)
      @loan = loan
      @borrower = @loan.borrower
      @current_employment ||= @borrower.employments.find_by(is_current: true)
      @previous_employment ||= @borrower.employments.find_by(is_current: false)

      return false unless employment_completed?
      return false unless @current_employment.duration >= 2 || (@current_employment.duration < 2 && previous_employment_completed?)
      return false unless @borrower.gross_income

      true
    end

    def self.employment_completed?
      return false unless @current_employment.employer_name.present?
      return false unless @current_employment.address.present?
      return false unless @current_employment.employer_contact_name.present?
      return false unless @current_employment.employer_contact_number.present?
      return false unless @current_employment.current_salary.present?
      return false unless @current_employment.job_title.present?
      return false unless @current_employment.pay_frequency.present?
      return false unless @current_employment.duration.present?

      true
    end

    def self.previous_employment_completed?
      return false unless @previous_employment.employer_name.present?
      return false unless @previous_employment.job_title.present?
      return false unless @previous_employment.duration.present?
      return false unless @previous_employment.monthly_income.present?

      true
    end
  end
end
