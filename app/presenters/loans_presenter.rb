class LoansPresenter
  def initialize(loans)
    @loans = loans
  end

  def show_loans
    @loans.as_json(show_loans_json_options)
  end

  private

  def show_loans_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        }
      }
    }
  end

end