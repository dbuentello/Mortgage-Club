class LoanMembers::LenderDocumentsPresenter
  def initialize(documents)
    @documents = documents
  end

  def show
    @documents.as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        loan: {
          only: [:id]
        },
        user: {
          methods: [:to_s, :avatar_url]
        }
      }
    }
  end
end
