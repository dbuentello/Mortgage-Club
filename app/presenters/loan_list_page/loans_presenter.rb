class LoanListPage::LoansPresenter
  def initialize(loans)
    @loans = loans
  end

  def show
    @loans.as_json(show_loans_json_options)
  end

  private

  def show_loans_json_options
    {
      only: [:id, :created_at, :amount, :interest_rate],
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        }
      },
      methods: [:pretty_status]
    }
  end
end
