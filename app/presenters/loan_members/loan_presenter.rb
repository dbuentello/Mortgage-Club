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
        documents: {},
        lender_documents: {}
      },
      methods: [:other_lender_documents, :pretty_status]
    }
  end
end
