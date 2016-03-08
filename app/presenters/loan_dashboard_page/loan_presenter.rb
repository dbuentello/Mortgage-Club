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
        :down_payment, :estimated_cash_to_close,
        :loan_costs,
        :third_party_fees, :monthly_payment,
        :lender_credits, :estimated_prepaid_items],
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
