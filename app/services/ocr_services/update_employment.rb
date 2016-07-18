module OcrServices
  #
  # Class UpdateEmployment provides updating employment's data
  #
  #
  class UpdateEmployment
    attr_reader :data, :borrower_id, :employment

    def initialize(data, borrower_id)
      @data = data
      @borrower_id = borrower_id
      if @borrower = Borrower.find_by_id(borrower_id)
        @employment = @borrower.current_employment
      end
    end

    #
    # If employment is present, we just update it. Otherwise, we create a new employment
    #
    #
    # @return [<type>] <description>
    #
    def call
      return unless @borrower && data

      if employment.present?
        update_employment
        create_employer_address(employment) unless employment.address.present?
      else
        new_employment = create_new_employment
        create_employer_address(new_employment)
      end
    end

    private

    def update_employment
      employment.update(
        employer_name: employment.employer_name || data[:employer_name],
        pay_frequency: data[:period],
        current_salary: data[:current_salary],
        ytd_salary: data[:ytd_salary]
      )
    end

    def create_new_employment
      Employment.create(
        borrower_id: borrower_id,
        employer_name: data[:employer_name],
        pay_frequency: data[:period],
        current_salary: data[:current_salary],
        ytd_salary: data[:ytd_salary],
        is_current: true
      )
    end

    def create_employer_address(employment)
      Address.create(
        employment_id: employment.id,
        full_text: data[:employer_full_address]
      )
    end
  end
end
