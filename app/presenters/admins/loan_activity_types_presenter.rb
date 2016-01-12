class Admins::LoanActivityTypesPresenter
  def initialize(activity_types)
    @activity_types = activity_types
  end

  def show
    @activity_types.as_json(json_options)
  end

  private

  def json_options
    {
      only: [ :id, :label, :type_name_mapping ]
    }
  end
end
