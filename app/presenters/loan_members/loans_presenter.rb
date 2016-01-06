class LoanMembers::LoansPresenter
  def initialize(loans)
    @loans = loans
  end

  def show
    @loans.as_json(show_loans_json_options)
  end

  private

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
        },
        subject_property: {
          include: :address
        },
      }
    }
  end
end
