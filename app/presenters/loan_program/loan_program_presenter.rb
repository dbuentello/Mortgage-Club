class LoanProgram::LoanProgramPresenter
  def initialize(loan)
    @loan = loan
  end

  def show
    @loan.as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        rental_properties: {
          include: :address,
          methods: [:mortgage_payment_liability, :other_financing_liability]
        },
        primary_property: {
          include: :address,
          methods: [:mortgage_payment_liability, :other_financing_liability]
        },
        subject_property: {
          only: [:address, :estimated_property_tax, :estimated_hazard_insurance, :estimated_mortgage_insurance, :hoa_due],
          methods: [:mortgage_payment_liability, :other_financing_liability]
        },
        borrower: {
          include: [
            :declaration, :documents, :assets,
            user: {
              only: [ :email, :first_name ]
            }
          ],
          methods: [
            :current_address, :previous_address, :current_employment, :previous_employment,
            :first_name, :last_name, :middle_name, :suffix
          ]
        },
        secondary_borrower: {
          include: [
            :declaration, :documents,
            user: {
              only: [ :email ]
            }
          ],
          methods: [
            :current_address, :previous_address, :current_employment, :previous_employment,
            :first_name, :last_name, :middle_name, :suffix
          ]
        }
      },
      methods: [
        :property_completed, :borrower_completed, :income_completed, :credit_completed, :assets_completed, :declarations_completed, :primary_property, :subject_property, :rental_properties
      ]
    }
  end
end
