class LoanDashboardPage::LoanPresenter
  def initialize(loan)
    @loan = loan
  end

  def show
    @loan.as_json(json_options)
  end

  private

  def json_options
    {
      only: [ :id, :amount, :created_at, :interest_rate, :amortization_type,
        :estimated_prepaid_items,
        :loan_type, :lender_credits ],
      include: {
        properties: {
          only: [:id],
          include: {
            address: {
              only: [],
              methods: :address
            }
          },
          methods: :usage_name
        },
        borrower: {
          only: [:id],
          include: [
            :documents
          ]
        },
        closing: {
          only: [:id]
        }
      },
      methods: [
        :num_of_years, :purpose_titleize, :primary_property, :subject_property, :pretty_status
      ]
    }
  end
end
