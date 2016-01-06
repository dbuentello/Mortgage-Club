class LoanDashboardPage::ChecklistsPresenter
  def initialize(checklists)
    @checklists = checklists
  end

  def show
    @checklists.includes(:user).as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :status, :subject_name, :checklist_type, :name, :info,
             :due_date, :document_type, :document_description],
      include: {
        loan: {
          only: [:id]
        },
        user: {
          methods: [:to_s, :avatar_url]
        }
      },
      methods: [:document_info]
    }
  end
end
