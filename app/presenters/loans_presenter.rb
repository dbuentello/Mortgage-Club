class LoansPresenter
  def initialize(loans)
    @loans = loans
  end

  def show
    @loans.includes(properties: :address).as_json(show_loans_json_options)
  end

  def show_dashboard
    @loans.as_json(show_loans_dashboard_json_options)
  end

  private

  def show_loans_dashboard_json_options
    {
      only: [:id, :created_at, :amount, :interest_rate],
      include: {
        user: {
          only: [:email],
          methods: [:to_s]
        }
      }
    }
  end

  def show_loans_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        },
        properties: {
          include: :address
        },
        primary_property: {
          include: :address
        }
      }
    }
  end

end