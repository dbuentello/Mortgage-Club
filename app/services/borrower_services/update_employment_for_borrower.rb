module BorrowerServices
  class UpdateEmploymentForBorrower
    attr_accessor :borrower

    def initialize(borrower)
      @borrower = borrower
    end

    def call
      return if borrower.nil? || borrower.user.nil?

      person_info = FullContactServices::GetPersonalInfo.new(borrower.user.email).call

      return unless person_info[:crr_job_info][:years]

      borrower.employments.create(
        job_title: person_info[:crr_job_info][:title],
        duration: person_info[:crr_job_info][:years],
        employer_name: person_info[:crr_job_info][:company_name],
        is_current: true
      )

      if person_info[:prev_job_info][:years]
        borrower.employments.create(
          job_title: person_info[:prev_job_info][:title],
          duration: person_info[:prev_job_info][:years],
          employer_name: person_info[:prev_job_info][:company_name],
          is_current: false
        )
      end
    end
  end
end
