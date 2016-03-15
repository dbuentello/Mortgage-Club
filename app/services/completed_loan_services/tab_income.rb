module CompletedLoanServices
  class TabIncome
    attr_accessor :borrower, :current_employment,
                  :previous_employment, :secondary_borrower

    def initialize(args)
      @borrower = args[:borrower]
      @current_employment = args[:current_employment]
      @previous_employment = args[:previous_employment]
      @secondary_borrower = args[:secondary_borrower]
    end

    def call
      return false unless current_employment
      return false unless employment_completed?(current_employment)
      return false unless current_employment_duration_valid?
      return false unless borrower.gross_income

      unless secondary_borrower.nil?
        return false unless secondary_borrower.current_employment
        return false unless employment_completed?(secondary_borrower.current_employment)
        return false unless co_current_employment_duration_valid?
        return false unless secondary_borrower.gross_income
      end

      true
    end

    def employment_completed?(employment)
      return false unless employment.employer_name.present?
      return false unless employment.address.present?
      return false unless employment.employer_contact_name.present?
      return false unless employment.employer_contact_number.present?
      return false unless employment.current_salary.present?
      return false unless employment.job_title.present?
      return false unless employment.pay_frequency.present?
      return false unless employment.duration.present?

      true
    end

    def current_employment_duration_valid?
      current_employment.duration >= 2 || (current_employment.duration < 2 && previous_employment_completed?(previous_employment))
    end

    def co_current_employment_duration_valid?
      secondary_borrower.current_employment.duration >= 2 || (secondary_borrower.current_employment.duration < 2 && previous_employment_completed?(secondary_borrower.previous_employment))
    end

    def previous_employment_completed?(prev_employment)
      return false unless prev_employment
      return false unless prev_employment.employer_name.present?
      return false unless prev_employment.job_title.present?
      return false unless prev_employment.duration.present?
      return false unless prev_employment.monthly_income.present?

      true
    end
  end
end
