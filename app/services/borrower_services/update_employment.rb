module BorrowerServices
  class UpdateEmployment
    attr_accessor :borrower

    def initialize(borrower)
      @borrower = borrower
    end

    def call
      return if borrower.nil? || borrower.user.nil?

      personal_info = FullContactServices::GetPersonalInfo.new(borrower.user.email).call

      update_current_employment(personal_info[:current_job_info], borrower)
      update_prev_employment(personal_info[:prev_job_info], borrower)
    end

    def update_current_employment(current_job_info, borrower)
      return unless job_info_valid?(current_job_info)

      company_info = ClearbitServices::Discovery.new(current_job_info[:company_name]).call

      current_employment = Employment.new(
        job_title: current_job_info[:title],
        duration: current_job_info[:years],
        employer_name: current_job_info[:company_name],
        employer_contact_name: company_info[:contact_name],
        employer_contact_number: company_info[:contact_phone_number],
        is_current: true,
        borrower: borrower
      )

      if address_info_valid?(company_info)
        current_employment.address = Address.new(
          city: company_info[:city],
          state: company_info[:state],
          zip: company_info[:zip],
          street_address: company_info[:street_address]
        )
      end

      logger.error current_employment.errors.full_messages unless current_employment.save
    end

    def update_prev_employment(prev_job_info, borrower)
      return unless job_info_valid?(prev_job_info)

      prev_employment = Employment.new(
        job_title: prev_job_info[:title],
        duration: prev_job_info[:years],
        employer_name: prev_job_info[:company_name],
        is_current: false,
        borrower: borrower
      )

      prev_employment.save

      logger.error prev_employment.errors.full_messages unless prev_employment.save
    end

    def job_info_valid?(job)
      return true if job[:title] && job[:company_name]

      false
    end

    def address_info_valid?(address)
      return true if address[:city] || address[:state] || address[:zip] || address[:street_address]

      false
    end
  end
end
