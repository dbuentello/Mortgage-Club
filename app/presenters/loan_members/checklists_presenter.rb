class LoanMembers::ChecklistsPresenter
  def initialize(checklists)
    @checklists = checklists
  end

  def show
    @checklists.includes(:user).as_json(json_options)
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
      methods: [:type_humanize]
    }
  end
end
