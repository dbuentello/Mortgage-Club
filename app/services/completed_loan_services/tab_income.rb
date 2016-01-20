module CompletedLoanServices
  class TabIncome
    attr_accessor :borrower, :current_employment,
                  :previous_employment

    def initialize(args)
      @borrower = args[:borrower]
      @current_employment = args[:current_employment]
      @previous_employment = args[:previous_employment]
    end

    def call
      return false unless current_employment
      return false unless employment_completed?
      return false unless current_employment_duration_valid?
      return false unless borrower.gross_income

      true
    end

    def employment_completed?
      return false unless current_employment.employer_name.present?
      return false unless current_employment.address.present?
      return false unless current_employment.employer_contact_name.present?
      return false unless current_employment.employer_contact_number.present?
      return false unless current_employment.current_salary.present?
      return false unless current_employment.job_title.present?
      return false unless current_employment.pay_frequency.present?
      return false unless current_employment.duration.present?

      true
    end

    def current_employment_duration_valid?
      current_employment.duration >= 2 || (current_employment.duration < 2 && previous_employment_completed?)
    end

    def previous_employment_completed?
      return false unless previous_employment
      return false unless previous_employment.employer_name.present?
      return false unless previous_employment.job_title.present?
      return false unless previous_employment.duration.present?
      return false unless previous_employment.monthly_income.present?

      true
    end
  end
end
