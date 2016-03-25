module BorrowerServices
  class UpdateEmploymentForBorrower
    attr_accessor :borrower

    def initialize(borrower)
      @borrower = borrower
    end

    def call
      return if borrower.nil? || borrower.user.nil?

      personal_info = FullContactServices::GetPersonalInfo.new(borrower.user.email).call

      return unless valid_job_info?(personal_info[:current_job_info])

      company_info = ClearbitServices::Discovery.new(personal_info[:current_job_info][:company_name]).call

      current_employment = Employment.new(
        job_title: personal_info[:current_job_info][:title],
        duration: personal_info[:current_job_info][:years],
        employer_name: personal_info[:current_job_info][:company_name],
        employer_contact_name: company_info[:contact_name],
        employer_contact_number: company_info[:contact_phone_number],
        is_current: true,
        borrower: borrower
      )

      if valid_address_info?(company_info)
        current_employment.address = Address.new(
          city: company_info[:city],
          state: company_info[:state],
          zip: company_info[:zip],
          street_address: company_info[:street_address]
        )
      end

      current_employment.save

      if valid_job_info?(personal_info[:prev_job_info])
        prev_employment = Employment.new(
          job_title: personal_info[:prev_job_info][:title],
          duration: personal_info[:prev_job_info][:years],
          employer_name: personal_info[:prev_job_info][:company_name],
          is_current: false,
          borrower: borrower
        )

        prev_employment.save
      end
    end

    def valid_job_info?(job)
      return true if job[:title] && job[:years] && job[:company_name]

      false
    end

    def valid_address_info?(address)
      return true if address[:city] || address[:state] || address[:zip] || address[:street_address]

      false
    end
  end
end
