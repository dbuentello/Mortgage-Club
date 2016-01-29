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
      only: [:id, :amount],
      include: {
        subject_property: {
          only: [:address, :estimated_property_tax, :estimated_hazard_insurance, :estimated_mortgage_insurance, :hoa_due],
          methods: [:mortgage_payment_liability, :other_financing_liability]
        }
      },
      methods: [
        :subject_property
      ]
    }
  end
end
