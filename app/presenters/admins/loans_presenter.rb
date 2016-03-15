class Admins::LoansPresenter
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
          only: [:email, :first_name, :last_name]
        },
        properties: {
          include: :address
        },
        primary_property: {
          include: :address
        },
        subject_property: {
          include: :address
        }
      }
    }
  end
end
