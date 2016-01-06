class LoanMembers::LenderTemplatePresenter
  def initialize(template)
    @template = template
  end

  def show
    @template.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :name, :description, :is_other]
    }
  end
end
