module BorrowerServices
  class UpdateEmploymentForBorrower
    attr_accessor :borrower

    def initialize(borrower)
      @borrower = borrower
    end

    def call
      return if borrower.nil? || borrower.user.nil?

      personal_info = FullContactServices::GetPersonalInfo.new(borrower.user.email).call

      return unless personal_info[:current_job_info][:years]

      borrower.employments.create(
        job_title: personal_info[:current_job_info][:title],
        duration: personal_info[:current_job_info][:years],
        employer_name: personal_info[:current_job_info][:company_name],
        is_current: true
      )

      if personal_info[:prev_job_info][:years]
        borrower.employments.create(
          job_title: personal_info[:prev_job_info][:title],
          duration: personal_info[:prev_job_info][:years],
          employer_name: personal_info[:prev_job_info][:company_name],
          is_current: false
        )
      end
    end
  end
end
