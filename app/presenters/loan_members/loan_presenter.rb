class LoanMembers::LoanPresenter
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
        user: {
          only: [:email],
          methods: [:to_s]
        },
        checklists: {
          include: {
            user: {
              methods: [:to_s]
            }
          }
        },
        borrower: {
          include: [
            documents: {}
          ]
        },
        secondary_borrower: {
          include: [
            documents: {}
          ]
        },
        documents: {},
        lender_documents: {},
        lender: {
          only: [:id]
        }
      },
      methods: [:other_lender_documents, :pretty_status, :other_documents]
    }
  end
end
