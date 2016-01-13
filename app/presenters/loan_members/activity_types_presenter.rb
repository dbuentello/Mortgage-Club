class LoanMembers::ActivityTypesPresenter
  def initialize(activity_types)
    @activity_types = activity_types
  end

  def show
    @activity_types.as_json(json_options)
  end

  private

  def json_options
    {
    }
  end
end
