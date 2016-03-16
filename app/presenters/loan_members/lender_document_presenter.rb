class LoanMembers::LenderDocumentPresenter
  def initialize(document)
    @document = document
  end

  def show
    @document.as_json(json_options)
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
