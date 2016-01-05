class LoanDashboardPage::DocumentsPresenter
  def initialize(documents)
    @documents = documents
  end

  def show
    @documents.includes(:user).as_json(json_options)
  end

  private

  def json_options
    {
      include: {
        user: {
          methods: [:to_s]
        }
      },
      methods: [:file_icon_url]
    }
  end
end
