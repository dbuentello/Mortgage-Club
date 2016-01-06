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
      only: [:id, :original_filename, :attachment_file_name, :description, :attachment_updated_at, :updated_at],
      include: {
        user: {
          only: [:first_name],
          methods: [:to_s]
        }
      },
      methods: [:file_icon_url]
    }
  end
end
