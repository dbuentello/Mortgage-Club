class LoansPresenter
  def initialize(loans)
    @loans = loans
  end

  def show
    @loans.includes(property: :address).as_json(show_loans_json_options)
  end

  private

  def show_loans_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        },
        property: {
          include: :address
        }
      }
    }
  end

end