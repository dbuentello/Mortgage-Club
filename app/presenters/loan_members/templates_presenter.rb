class LoanMembers::TemplatesPresenter
  def initialize(templates)
    @templates = templates
  end

  def show
    @templates.as_json(json_options)
  end

  private

  def json_options
    {}
  end
end
