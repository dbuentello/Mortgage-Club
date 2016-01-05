class LoanMembers::ChecklistPresenter
  def initialize(checklists)
    @checklists = checklists
  end

  def show
    @checklist.as_json(json_options)
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
      },
      methods: [:document_info]
    }
  end
end
