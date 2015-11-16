module OcrServices
  class UpdateEmployment
    attr_reader :data, :borrower_id, :employment

    def initialize(data, borrower_id)
      @data = data
      @borrower_id = borrower_id
      if @borrower = Borrower.find_by_id(borrower_id)
        @employment = @borrower.current_employment
      end
    end

    def call
      return unless @borrower && data

      if employment.present?
        update_employment
      else
        new_employment = create_new_employment
        create_employer_address(new_employment)
      end
    end

    private

    def update_employment
      employment.update(
        employer_name: data[:employer_name],
        pay_frequency: data[:period],
        current_salary: data[:current_salary],
        ytd_salary: data[:ytd_salary]
      )

      if employment.address.present?
        update_employer_address
      else
        create_employer_address(employment)
      end
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

    def update_employer_address
      employment.address.update(full_text: data[:employer_full_address])
    end
  end
end