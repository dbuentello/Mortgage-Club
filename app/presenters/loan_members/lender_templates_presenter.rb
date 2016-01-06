class LoanMembers::LenderTemplatesPresenter
  def initialize(templates)
    @templates = templates
  end

  def show
    @templates.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :name, :description, :is_other]
    }
  end
end
